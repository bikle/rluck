--
-- 6hma.sql
--

-- I use this script to help me answer the question,
-- Is moving average slope predictive?

CREATE OR REPLACE VIEW v6hma10 AS
SELECT
pair
-- ydate is granular down to the hour:
,ydate
,opn
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
,LEAD(clse,5,NULL)OVER(PARTITION BY pair ORDER BY ydate) clse6
FROM hourly 
WHERE ydate >'2009-01-01'
-- Prevent divide by zero:
AND opn > 0
-- Focus on aud_usd for now:
ORDER BY ydate
/

-- I should see 6 x 6:
SELECT pair,COUNT(*)FROM v6hma10 WHERE ydate6 IS NULL GROUP BY pair;
-- I should see 6 x 5:
SELECT pair,COUNT(*)FROM v6hma10 WHERE clse6 IS NULL GROUP BY pair;

-- I derive slope of moving-averages:
CREATE OR REPLACE VIEW v6hma AS
SELECT
pair
,ydate
,(ma2_6 - ma1_6)ma6_slope
,(ma2_9 - ma1_9)ma9_slope
,(ma2_12 - ma1_12)ma12_slope
,(ma2_18 - ma1_18)ma18_slope
,ydate6
,clse6
,(clse6 - opn)/opn npg
FROM v6hma10
ORDER BY ydate
/

-- Is ma_slope correlated with npg?
SELECT 
pair
,COUNT(npg)
,CORR(ma6_slope,npg)
,CORR(ma9_slope,npg)
,CORR(ma12_slope,npg)
,CORR(ma18_slope,npg)
FROM v6hma
GROUP BY pair
ORDER BY pair
/

exit
