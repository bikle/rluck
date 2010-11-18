--
-- svm6.sql
--

CREATE OR REPLACE VIEW svm610 AS
SELECT
pair
-- ydate is granular down to the hour:
,ydate
,clse
-- Use analytic function to get moving average1:
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 7 PRECEDING AND 1 PRECEDING)ma1_6
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 10 PRECEDING AND 1 PRECEDING)ma1_9
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 13 PRECEDING AND 1 PRECEDING)ma1_12
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 19 PRECEDING AND 1 PRECEDING)ma1_18
-- Use analytic function to get moving average2:
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 6 PRECEDING AND CURRENT ROW)ma2_6
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 9 PRECEDING AND CURRENT ROW)ma2_9
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12 PRECEDING AND CURRENT ROW)ma2_12
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 18 PRECEDING AND CURRENT ROW)ma2_18
-- Get ydate 6 hours in the future:
,LEAD(ydate,6,NULL)OVER(PARTITION BY pair ORDER BY ydate) ydate6
-- Get closing price 6 rows (usually 6 hours) in the future:
,LEAD(clse,6,NULL)OVER(PARTITION BY pair ORDER BY ydate) clse6
FROM hourly 
WHERE ydate >'2009-04-01'
-- Prevent divide by zero:
AND clse > 0
ORDER BY ydate
/

SELECT COUNT(*)FROM svm610 WHERE ydate6 IS NULL;
SELECT COUNT(*)FROM svm610 WHERE clse6 IS NULL;

-- I derive slope of moving-averages:
CREATE OR REPLACE VIEW svm6ms AS
SELECT
pair
,ydate
,pair||ydate prdate
,(ma2_6 - ma1_6)ma6_slope
,(ma2_9 - ma1_9)ma9_slope
,(ma2_12 - ma1_12)ma12_slope
,(ma2_18 - ma1_18)ma18_slope
,ydate6
,clse6
,(clse6 - clse)/clse npg
-- I use a simple CASE expression to build gatt which is the target attribute.
-- Notice that gatt can have 3 values,
-- NULL, 'up', and 'nup'.
-- To me, 'nup' means not-up rather than down:
,CASE WHEN clse6 IS NULL THEN NULL 
      WHEN (clse6 - clse)/clse > 0.0009 THEN 'up'
      ELSE 'nup' END gatt
FROM svm610
ORDER BY ydate
/

--rpt

-- I should see 6 x 6:
SELECT COUNT(*)FROM svm6ms WHERE ydate6 IS NULL;
-- I should see 6 x 6:
SELECT COUNT(*)FROM svm6ms WHERE clse6 IS NULL;
SELECT COUNT(*)FROM svm6ms WHERE gatt IS NULL;

SELECT COUNT(ydate)FROM svm610;

SELECT COUNT(ydate),AVG(ydate6-ydate),MIN(ydate6-ydate),MAX(ydate6-ydate) FROM svm6ms;

-- I should see no rows WHERE the date difference is less than 6 hours:
SELECT COUNT(ydate)FROM svm6ms WHERE (ydate6 - ydate) < 6/24;

-- I should see many rows WHERE the date difference is exactly 6 hours:
SELECT COUNT(ydate)FROM svm6ms WHERE (ydate6 - ydate) = 6/24;

-- I show up, nup distribution.
-- I should see 6 rows that are too far in the future to give me a gatt value yet:
SELECT NVL(gatt,'null_gatt')gatt,COUNT(NVL(gatt,'null_gatt'))FROM svm6ms GROUP BY NVL(gatt,'null_gatt');

-- Is ma_slope correlated with npg?
SELECT 
pair
,COUNT(npg)
,CORR(ma6_slope,npg)
,CORR(ma9_slope,npg)
,CORR(ma12_slope,npg)
,CORR(ma18_slope,npg)
FROM svm6ms
GROUP BY pair
/

exit
