--
-- qry_ibs1hr.sql
--

-- I use this script to look for dups and bad data in ibs1hr

SET LINES 66
DESC ibs1hr
SET LINES 166

SELECT
tkr
,COUNT(tkr)
FROM ibs1hr
GROUP BY tkr
ORDER BY tkr
/

-- Look for dups
SELECT COUNT(tkr)FROM
(
SELECT
tkr
,ydate
,COUNT(tkr)
FROM ibs1hr
GROUP BY tkr,ydate
HAVING COUNT(tkr)>1
)
/

-- Use LAG() to look for big jumps.

CREATE OR REPLACE VIEW ibs1hr10 AS
SELECT
tkr
-- ydate is granular down to 1 hr:
,ydate
,clse
-- Use analytic function to get LAG()
,LAG(ydate,1,NULL)OVER(PARTITION BY tkr ORDER BY ydate)              lag_ydate
,(ydate - LAG(ydate,1,NULL)OVER(PARTITION BY tkr ORDER BY ydate))*24*60 minutes_diff
,LAG(clse,1,NULL)OVER(PARTITION BY tkr ORDER BY ydate)               lag_clse
,(clse - LAG(clse,1,NULL)OVER(PARTITION BY tkr ORDER BY ydate))/clse lag_diff
FROM ibs1hr
WHERE clse>0
ORDER BY tkr, ydate
/

CREATE OR REPLACE VIEW ibs1hr_ld AS
SELECT
tkr
,MIN(lag_diff)    min_lag_diff
,AVG(lag_diff)    avg_lag_diff
,STDDEV(lag_diff) stddev_lag_diff
,MAX(lag_diff)    max_lag_diff
,COUNT(lag_diff)  cnt_lag_diff
FROM ibs1hr10
GROUP BY tkr
/

SELECT * FROM ibs1hr_ld;

SELECT * FROM ibs1hr10 WHERE lag_diff = (SELECT MIN(min_lag_diff)FROM ibs1hr_ld);

SELECT * FROM ibs1hr10 WHERE lag_diff = (SELECT MAX(max_lag_diff)FROM ibs1hr_ld);

-- SELECT COUNT(*)FROM ibs1hr10 WHERE lag_diff IN(SELECT max_lag_diff FROM ibs1hr_ld);

-- Get a closer look at the smallest lag_diffs:

-- SELECT COUNT(l.tkr)
SELECT
l.tkr
,TO_CHAR(i.ydate,'Day')dday
,i.ydate
,i.lag_clse
,i.clse
,i.lag_diff
,i.lag_diff/stddev_lag_diff ld_st_ratio
,i.minutes_diff
FROM ibs1hr_ld l, ibs1hr10 i
WHERE l.min_lag_diff = i.lag_diff
ORDER BY i.ydate,l.tkr
/

-- Get a closer look at the largest lag_diffs:

-- SELECT COUNT(l.tkr)
SELECT
l.tkr
,TO_CHAR(i.ydate,'Day')dday
,i.ydate
,i.lag_clse
,i.clse
,i.lag_diff
,i.lag_diff/stddev_lag_diff ld_st_ratio
,i.minutes_diff
FROM ibs1hr_ld l, ibs1hr10 i
WHERE l.max_lag_diff = i.lag_diff
ORDER BY i.ydate,l.tkr
/

-- I want to see rows around the rows which are connected to the max/min clse values

CREATE OR REPLACE VIEW ibs1hr12 AS
SELECT
tkr
-- ydate is granular down to 1 hr:
,ydate
,LAG(clse,3,NULL)OVER(PARTITION BY tkr ORDER BY ydate) lag_clse3
,LAG(clse,2,NULL)OVER(PARTITION BY tkr ORDER BY ydate) lag_clse2
,LAG(clse,1,NULL)OVER(PARTITION BY tkr ORDER BY ydate) lag_clse1
,clse
,LEAD(clse,1,NULL)OVER(PARTITION BY tkr ORDER BY ydate) lead_clse1
,LEAD(clse,2,NULL)OVER(PARTITION BY tkr ORDER BY ydate) lead_clse2
,LEAD(clse,3,NULL)OVER(PARTITION BY tkr ORDER BY ydate) lead_clse3
,(clse - LAG(clse,1,NULL)OVER(PARTITION BY tkr ORDER BY ydate))/clse lag_diff
FROM ibs1hr
WHERE clse>0
ORDER BY tkr, ydate
/

-- Now join ibs1hr12 with ibs1hr_ld

SELECT
l.tkr
,i.ydate
,lag_clse3
,lag_clse2
,lag_clse1
,lag_diff
,i.clse
,lead_clse1
,lead_clse2
,lead_clse3
FROM ibs1hr_ld l, ibs1hr12 i
WHERE l.max_lag_diff = i.lag_diff
OR    l.min_lag_diff = i.lag_diff
ORDER BY i.ydate,l.tkr
/

-- Look at what is recent

SELECT
tkr
,ydate
,clse
FROM ibs1hr
WHERE ydate > sysdate - 1.5/24
ORDER BY tkr,ydate
/

-- Look at date ranges

SELECT
tkr
,MIN(ydate)
,COUNT(ydate)
,MAX(ydate)
FROM ibs1hr
GROUP BY tkr
ORDER BY tkr
/

exit
