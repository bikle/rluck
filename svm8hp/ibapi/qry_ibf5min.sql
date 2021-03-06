--
-- qry_ibf5min.sql
--

-- I use this script to look for dups and bad data in ibf5min

SET LINES 66
DESC ibf5min
SET LINES 166

SELECT
pair
,COUNT(pair)
FROM ibf5min
GROUP BY pair
ORDER BY pair
/

-- Look for dups
SELECT COUNT(pair)FROM
(
SELECT
pair
,ydate
,COUNT(pair)
FROM ibf5min
GROUP BY pair,ydate
HAVING COUNT(pair)>1
)
/

-- Use LAG() to look for big jumps.

CREATE OR REPLACE VIEW ibf5min10 AS
SELECT
pair
-- ydate is granular down to 5 min:
,ydate
,clse
-- Use analytic function to get LAG()
,LAG(ydate,1,NULL)OVER(PARTITION BY pair ORDER BY ydate)              lag_ydate
,(ydate - LAG(ydate,1,NULL)OVER(PARTITION BY pair ORDER BY ydate))*24*60 minutes_diff
,LAG(clse,1,NULL)OVER(PARTITION BY pair ORDER BY ydate)               lag_clse
,(clse - LAG(clse,1,NULL)OVER(PARTITION BY pair ORDER BY ydate))/clse lag_diff
FROM ibf5min
WHERE clse>0
ORDER BY pair, ydate
/

CREATE OR REPLACE VIEW ibf5min_ld AS
SELECT
pair
,MIN(lag_diff)    min_lag_diff
,AVG(lag_diff)    avg_lag_diff
,STDDEV(lag_diff) stddev_lag_diff
,MAX(lag_diff)    max_lag_diff
,COUNT(lag_diff)  cnt_lag_diff
FROM ibf5min10
GROUP BY pair
/

SELECT * FROM ibf5min_ld;

SELECT * FROM ibf5min10 WHERE lag_diff = (SELECT MIN(min_lag_diff)FROM ibf5min_ld);

SELECT * FROM ibf5min10 WHERE lag_diff = (SELECT MAX(max_lag_diff)FROM ibf5min_ld);

-- SELECT COUNT(*)FROM ibf5min10 WHERE lag_diff IN(SELECT max_lag_diff FROM ibf5min_ld);

-- Get a closer look at the smallest lag_diffs:

-- SELECT COUNT(l.pair)
SELECT
l.pair
,TO_CHAR(i.ydate,'Day')dday
,i.ydate
,i.lag_clse
,i.clse
,i.lag_diff
,i.lag_diff/stddev_lag_diff ld_st_ratio
,i.minutes_diff
FROM ibf5min_ld l, ibf5min10 i
WHERE l.min_lag_diff = i.lag_diff
ORDER BY i.ydate,l.pair
/

-- Get a closer look at the largest lag_diffs:

-- SELECT COUNT(l.pair)
SELECT
l.pair
,TO_CHAR(i.ydate,'Day')dday
,i.ydate
,i.lag_clse
,i.clse
,i.lag_diff
,i.lag_diff/stddev_lag_diff ld_st_ratio
,i.minutes_diff
FROM ibf5min_ld l, ibf5min10 i
WHERE l.max_lag_diff = i.lag_diff
ORDER BY i.ydate,l.pair
/

-- I want to see rows around the rows which are connected to the max/min clse values

CREATE OR REPLACE VIEW ibf5min12 AS
SELECT
pair
-- ydate is granular down to 5 min:
,ydate
,LAG(clse,3,NULL)OVER(PARTITION BY pair ORDER BY ydate) lag_clse3
,LAG(clse,2,NULL)OVER(PARTITION BY pair ORDER BY ydate) lag_clse2
,LAG(clse,1,NULL)OVER(PARTITION BY pair ORDER BY ydate) lag_clse1
,clse
,LEAD(clse,1,NULL)OVER(PARTITION BY pair ORDER BY ydate) lead_clse1
,LEAD(clse,2,NULL)OVER(PARTITION BY pair ORDER BY ydate) lead_clse2
,LEAD(clse,3,NULL)OVER(PARTITION BY pair ORDER BY ydate) lead_clse3
,(clse - LAG(clse,1,NULL)OVER(PARTITION BY pair ORDER BY ydate))/clse lag_diff
FROM ibf5min
WHERE clse>0
ORDER BY pair, ydate
/

-- Now join ibf5min12 with ibf5min_ld

SELECT
l.pair
,i.ydate
,lag_clse3
,lag_clse2
,lag_clse1
,lag_diff
,i.clse
,lead_clse1
,lead_clse2
,lead_clse3
FROM ibf5min_ld l, ibf5min12 i
WHERE l.max_lag_diff = i.lag_diff
OR    l.min_lag_diff = i.lag_diff
ORDER BY i.ydate,l.pair
/

-- Look at what is recent

SELECT
pair
,ydate
,clse
FROM ibf5min
WHERE ydate > sysdate - 1.5/24
ORDER BY pair,ydate
/

exit
