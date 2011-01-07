--
-- find_bad_goog_data.sql
--

-- I use this script to look at some abnormally large gains in di1hr_stk WHERE tkr='GOOG'

-- I pattern this script after:
-- svm6/ibapi/qry_ibf5min.sql


SET LINES 66
DESC di1hr_stk
SET LINES 166


-- Use LAG() to look for big jumps.

CREATE OR REPLACE VIEW di1hr_stk_bd0 AS
SELECT
tkrdate
,tkr
,ydate
,clse
-- Use analytic function to get LAG()
,LAG(ydate,1,NULL)OVER(PARTITION BY tkr ORDER BY ydate)              lag_ydate
,(ydate - LAG(ydate,1,NULL)OVER(PARTITION BY tkr ORDER BY ydate))*24*60 minutes_diff
,LAG(clse,1,NULL)OVER(PARTITION BY tkr ORDER BY ydate)               lag_clse
,(clse - LAG(clse,1,NULL)OVER(PARTITION BY tkr ORDER BY ydate))/clse lag_diff
FROM di1hr_stk
WHERE clse>0
ORDER BY tkr, ydate
/

-- Look at each tkr:

CREATE OR REPLACE VIEW di1hr_stk_bd0_ld AS
SELECT
tkr
,MIN(lag_diff)    min_lag_diff
,AVG(lag_diff)    avg_lag_diff
,STDDEV(lag_diff) stddev_lag_diff
,MAX(lag_diff)    max_lag_diff
,COUNT(lag_diff)  cnt_lag_diff
FROM di1hr_stk_bd0
GROUP BY tkr
/


SELECT * FROM di1hr_stk_bd0_ld;

SELECT * FROM di1hr_stk_bd0 WHERE lag_diff = (SELECT MIN(min_lag_diff)FROM di1hr_stk_bd0_ld);

SELECT * FROM di1hr_stk_bd0 WHERE lag_diff = (SELECT MAX(max_lag_diff)FROM di1hr_stk_bd0_ld);

-- Get a closer look at the smallest lag_diffs:

SELECT COUNT(tkr)FROM
(
SELECT
l.tkr
,TO_CHAR(i.ydate,'Day')dday
,i.ydate
,i.lag_clse
,i.clse
,i.lag_diff
,i.lag_diff/stddev_lag_diff ld_st_ratio
,i.minutes_diff
FROM di1hr_stk_bd0_ld l, di1hr_stk_bd0 i
WHERE l.min_lag_diff = i.lag_diff
ORDER BY i.ydate,l.tkr
)
/

-- If above COUNT() is small, run this
-- to see the most negative lag_diffs:

SELECT
l.tkr
,TO_CHAR(i.ydate,'Day')dday
,i.ydate
,i.lag_clse
,i.clse
,i.lag_diff
,i.lag_diff/stddev_lag_diff ld_st_ratio
,i.minutes_diff
FROM di1hr_stk_bd0_ld l, di1hr_stk_bd0 i
WHERE l.min_lag_diff = i.lag_diff
ORDER BY i.ydate,l.tkr
/


-- If above COUNT() is small, run this:

-- Get a closer look at the largest lag_diffs:

SELECT
l.tkr
,TO_CHAR(i.ydate,'Day')dday
,i.ydate
,i.lag_clse
,i.clse
,i.lag_diff
,i.lag_diff/stddev_lag_diff ld_st_ratio
,i.minutes_diff
FROM di1hr_stk_bd0_ld l, di1hr_stk_bd0 i
WHERE l.max_lag_diff = i.lag_diff
ORDER BY i.ydate,l.tkr
/

-- I want to see rows around the rows which are connected to the max/min clse values

CREATE OR REPLACE VIEW di1hr_stk_bd2 AS
SELECT
tkr
-- ydate is granular down to 5 min:
,ydate
,LAG(clse,3,NULL)OVER(PARTITION BY tkr ORDER BY ydate) lag_clse3
,LAG(clse,2,NULL)OVER(PARTITION BY tkr ORDER BY ydate) lag_clse2
,LAG(clse,1,NULL)OVER(PARTITION BY tkr ORDER BY ydate) lag_clse1
,clse
,LEAD(clse,1,NULL)OVER(PARTITION BY tkr ORDER BY ydate) lead_clse1
,LEAD(clse,2,NULL)OVER(PARTITION BY tkr ORDER BY ydate) lead_clse2
,LEAD(clse,3,NULL)OVER(PARTITION BY tkr ORDER BY ydate) lead_clse3
,(clse - LAG(clse,1,NULL)OVER(PARTITION BY tkr ORDER BY ydate))/clse lag_diff
FROM di1hr_stk
WHERE clse>0
ORDER BY tkr, ydate
/


-- Now join di1hr_stk_bd2 with di1hr_stk_bd0_ld

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
FROM di1hr_stk_bd0_ld l, di1hr_stk_bd2 i
WHERE l.max_lag_diff = i.lag_diff
OR    l.min_lag_diff = i.lag_diff
ORDER BY i.ydate,l.tkr
/

-- Look at 2010-11-18

SELECT
tkr
,ydate
,clse
FROM di1hr_stk
WHERE ydate BETWEEN'2010-11-17'AND'2010-11-19'
ORDER BY tkr,ydate
/

