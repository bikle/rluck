--
-- 6hma.sql
--

-- I use this script to help me answer the question,
-- Is slope of moving average predictive?

CREATE OR REPLACE VIEW v6hma10 AS
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
WHERE ydate >'2007-07-01'
-- Prevent divide by zero:
AND clse > 0
ORDER BY ydate
/

-- rpt
SELECT
pair
,MIN(ydate)
,COUNT(ydate)
,MAX(ydate)
FROM v6hma10
GROUP BY pair
ORDER BY pair
/

-- I should see 6 x 6:
SELECT pair,COUNT(*)FROM v6hma10 WHERE ydate6 IS NULL GROUP BY pair;
SELECT pair,COUNT(*)FROM v6hma10 WHERE clse6 IS NULL GROUP BY pair;

-- I derive "normalized" slope of moving-averages.
-- Also, I derive normalized gain.
-- I normalize to prevent usd_jpy from skewing my results:
CREATE OR REPLACE VIEW v6hma12 AS
SELECT
pair
,ydate
,(ma2_6 - ma1_6)/ma1_6    ma6_slope
,(ma2_9 - ma1_9)/ma1_9    ma9_slope
,(ma2_12 - ma1_12)/ma1_12 ma12_slope
,(ma2_18 - ma1_18)/ma1_18 ma18_slope
,ydate6
,clse6
,(clse6 - clse)/clse npg
FROM v6hma10
ORDER BY ydate
/

-- I derive moving-stddev of slope of moving-averages:
CREATE OR REPLACE VIEW v6hma14 AS
SELECT
pair
,ydate
,ma6_slope
,ma9_slope
,ma12_slope
,ma18_slope
,ydate6
,clse6
,npg
,STDDEV(ma6_slope)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)stddev6
,STDDEV(ma9_slope)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)stddev9
,STDDEV(ma12_slope)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)stddev12
,STDDEV(ma18_slope)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)stddev18
FROM v6hma12
ORDER BY ydate
/

-- I derive steepness indicator from stddev:
CREATE OR REPLACE VIEW v6hma AS
SELECT
pair
,ydate
,ma6_slope
,ma9_slope
,ma12_slope
,ma18_slope
,ydate6
,clse6
,npg
,stddev6
,stddev9
,stddev12
,stddev18
-- 1 is normal steepness, 3 is very steep (and rare):
,CASE WHEN ABS(ma6_slope) < stddev6 THEN 1
      WHEN ABS(ma6_slope)BETWEEN stddev6 AND 2*stddev6 THEN 2
      WHEN ABS(ma6_slope)>2*stddev6 THEN 3 END steepness
FROM v6hma14
ORDER BY ydate
/

-- Now I can run some interesting queries:

-- Is ma_slope correlated with npg?
SELECT
pair
,CORR(ma6_slope,npg)
,COUNT(npg)
FROM v6hma
WHERE steepness > 0
GROUP BY pair
ORDER BY pair
/

-- Does CORR() change as steepness gets large?
SELECT
steepness
,pair
,CORR(ma6_slope,npg)
,COUNT(npg)
FROM v6hma
WHERE steepness > 0
GROUP BY steepness,pair
ORDER BY steepness,pair
/

-- When steepness < 3 npg lacks CORR() with slope.
-- But, Negative-CORR() seems noticeable when steepness is 3.
-- Take a closer look at steepness of 3.
-- Sign of slope seems like an obvious place to start:
SELECT
pair
,SIGN(ma6_slope)sgn
,CORR(ma6_slope,npg)
,AVG(npg)
,COUNT(npg)
,MIN(npg)
,STDDEV(npg)
,MAX(npg)
FROM v6hma
WHERE steepness = 3
GROUP BY SIGN(ma6_slope),pair
ORDER BY SIGN(ma6_slope),pair
/

-- This query shows a subset of the above query but makes it more readable:
SELECT
pair
,ROUND(AVG(npg),4)avg_n_gain
,ROUND(CORR(ma6_slope,npg),1)Slope_Gain_Correlation
,COUNT(npg)Rec_count
FROM v6hma
WHERE steepness = 3
AND SIGN(ma6_slope) = 1
GROUP BY pair
ORDER BY pair
/



exit
