--
-- svm4.sql
--

CREATE OR REPLACE VIEW svm410 AS
SELECT
pair
-- ydate is granular down to the hour:
,ydate
,opn
-- Use analytic function to get moving average1:
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 5 PRECEDING AND 1 PRECEDING)ma1_4
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 7 PRECEDING AND 1 PRECEDING)ma1_6
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 10 PRECEDING AND 1 PRECEDING)ma1_9
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 13 PRECEDING AND 1 PRECEDING)ma1_12
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 19 PRECEDING AND 1 PRECEDING)ma1_18
-- Use analytic function to get moving average2:
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 4 PRECEDING AND CURRENT ROW)ma2_4
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 6 PRECEDING AND CURRENT ROW)ma2_6
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 9 PRECEDING AND CURRENT ROW)ma2_9
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12 PRECEDING AND CURRENT ROW)ma2_12
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 18 PRECEDING AND CURRENT ROW)ma2_18
-- Get ydate 4 hours in the future:
,LEAD(ydate,4,NULL)OVER(PARTITION BY pair ORDER BY ydate) ydate4
-- Get closing price 3 rows (usually 4 hours) in the future:
,LEAD(clse,3,NULL)OVER(PARTITION BY pair ORDER BY ydate) clse4
FROM hourly 
WHERE ydate >'2009-01-01'
-- Prevent divide by zero:
AND opn > 0
-- Focus on aud_usd for now:
ORDER BY ydate
/

-- I should see 6 x 4:
SELECT COUNT(*)FROM svm410 WHERE ydate4 IS NULL

-- I should see 6 x 3:
SELECT COUNT(*)FROM svm410 WHERE clse4 IS NULL

-- I derive slope of moving-averages:
CREATE OR REPLACE VIEW svm4ms AS
SELECT
pair
,ydate
,pair||ydate prdate
,(ma2_4 - ma1_4)ma4_slope
,(ma2_6 - ma1_6)ma6_slope
,(ma2_9 - ma1_9)ma9_slope
,(ma2_12 - ma1_12)ma12_slope
,(ma2_18 - ma1_18)ma18_slope
,ydate4
,clse4
,(clse4 - opn)/opn npg
-- I use a simple CASE expression to build gatt which is the target attribute.
-- Notice that gatt can have 3 values,
-- NULL, 'up', and 'nup'.
-- To me, 'nup' means not-up rather than down:
,CASE WHEN clse4 IS NULL THEN NULL 
      WHEN (clse4 - opn)/opn > 0.0006 THEN 'up'
      ELSE 'nup' END gatt
FROM svm410
ORDER BY ydate
/

--rpt
-- I should see 6 x 4:

SELECT COUNT(*)FROM svm4ms WHERE ydate4 IS NULL

-- I should see 6 x 3:

SELECT COUNT(*)FROM svm4ms WHERE clse4 IS NULL

SELECT COUNT(*)FROM svm4ms WHERE gatt IS NULL

SELECT COUNT(ydate)FROM svm410

SELECT COUNT(ydate),AVG(ydate4-ydate),MIN(ydate4-ydate),MAX(ydate4-ydate) FROM svm4ms

-- I should see 0 rows where the diff is less than 4 hr:

SELECT COUNT(ydate)FROM svm4ms WHERE (ydate4 - ydate) < 4/24

-- I should see many rows WHERE the date difference is exactly 4 hours:

SELECT COUNT(ydate)FROM svm4ms WHERE (ydate4 - ydate) = 4/24

-- I show up, nup distribution.
-- I should see 6 x 3 rows that are too far in the future to give me a gatt value yet:

SELECT NVL(gatt,'null_gatt')gatt,COUNT(NVL(gatt,'null_gatt'))FROM svm4ms GROUP BY NVL(gatt,'null_gatt')

-- Is ma_slope correlated with npg?
SELECT 
pair
,COUNT(npg)
,CORR(ma4_slope,npg)
,CORR(ma6_slope,npg)
,CORR(ma9_slope,npg)
,CORR(ma12_slope,npg)
,CORR(ma18_slope,npg)
FROM svm4ms
GROUP BY pair


exit
