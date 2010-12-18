--
-- svm8.sql
--

CREATE OR REPLACE VIEW svm810 AS
SELECT
pair
-- ydate is granular down to the hour:
,ydate
,opn
-- Use analytic function to get moving average1:
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 7 PRECEDING AND 1 PRECEDING)ma1_6
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 9 PRECEDING AND 1 PRECEDING)ma1_8
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 10 PRECEDING AND 1 PRECEDING)ma1_9
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 13 PRECEDING AND 1 PRECEDING)ma1_12
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 19 PRECEDING AND 1 PRECEDING)ma1_18
-- Use analytic function to get moving average2:
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 6 PRECEDING AND CURRENT ROW)ma2_6
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 8 PRECEDING AND CURRENT ROW)ma2_8
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 9 PRECEDING AND CURRENT ROW)ma2_9
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12 PRECEDING AND CURRENT ROW)ma2_12
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 18 PRECEDING AND CURRENT ROW)ma2_18
-- Get ydate 8 hours in the future:
,LEAD(ydate,8,NULL)OVER(PARTITION BY pair ORDER BY ydate) ydate8
-- Get closing price 7 rows (usually 8 hours) in the future:
,LEAD(clse,7,NULL)OVER(PARTITION BY pair ORDER BY ydate) clse8
FROM hourly 
WHERE ydate >'2009-01-01'
-- Prevent divide by zero:
AND opn > 0
-- Focus on aud_usd for now:
ORDER BY ydate
/

SELECT COUNT(*)FROM svm810 WHERE ydate8 IS NULL;
SELECT COUNT(*)FROM svm810 WHERE clse8 IS NULL;

-- I derive slope of moving-averages:
CREATE OR REPLACE VIEW svm8ms AS
SELECT
pair
,ydate
,pair||ydate prdate
,(ma2_6 - ma1_6)ma6_slope
,(ma2_8 - ma1_8)ma8_slope
,(ma2_9 - ma1_9)ma9_slope
,(ma2_12 - ma1_12)ma12_slope
,(ma2_18 - ma1_18)ma18_slope
,ydate8
,clse8
,(clse8 - opn)/opn npg
-- I use a simple CASE expression to build gatt which is the target attribute.
-- Notice that gatt can have 3 values,
-- NULL, 'up', and 'nup'.
-- To me, 'nup' means not-up rather than down:
,CASE WHEN clse8 IS NULL THEN NULL 
      WHEN (clse8 - opn)/opn > 0.0009 THEN 'up'
      ELSE 'nup' END gatt
FROM svm810
ORDER BY ydate
/


--rpt

-- I should see 6 x 8:
SELECT COUNT(*)FROM svm8ms WHERE ydate8 IS NULL;
-- I should see 6 x 7:
SELECT COUNT(*)FROM svm8ms WHERE clse8 IS NULL;
SELECT COUNT(*)FROM svm8ms WHERE gatt IS NULL;

SELECT COUNT(ydate)FROM svm810;

SELECT COUNT(ydate),AVG(ydate8-ydate),MIN(ydate8-ydate),MAX(ydate8-ydate) FROM svm8ms;

-- I should see no rows WHERE the date difference is less than 8 hours:
SELECT COUNT(ydate)FROM svm8ms WHERE (ydate8 - ydate) < 8/24;

-- I should see many rows WHERE the date difference is exactly 8 hours:
SELECT COUNT(ydate)FROM svm8ms WHERE (ydate8 - ydate) = 8/24;

-- I show up, nup distribution.
-- I should see 7 rows that are too far in the future to give me a gatt value yet:
SELECT NVL(gatt,'null_gatt')gatt,COUNT(NVL(gatt,'null_gatt'))FROM svm8ms GROUP BY NVL(gatt,'null_gatt');

-- Is ma_slope correlated with npg?
SELECT 
pair
,COUNT(npg)
,CORR(ma6_slope,npg)
,CORR(ma8_slope,npg)
,CORR(ma9_slope,npg)
,CORR(ma12_slope,npg)
,CORR(ma18_slope,npg)
FROM svm8ms
GROUP BY pair
/

exit
