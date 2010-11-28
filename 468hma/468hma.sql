--
-- 468hma.sql
--

-- I use this script to help me answer the question,
-- Is moving average slope predictive?

CREATE OR REPLACE VIEW v468hma10 AS
SELECT
pair
-- ydate is granular down to the hour:
,ydate
,clse
-- Use analytic function to get moving average1:
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 5 PRECEDING AND 1 PRECEDING)ma1_4
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 7 PRECEDING AND 1 PRECEDING)ma1_6
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 9 PRECEDING AND 1 PRECEDING)ma1_8
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 10 PRECEDING AND 1 PRECEDING)ma1_9
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 13 PRECEDING AND 1 PRECEDING)ma1_12
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 19 PRECEDING AND 1 PRECEDING)ma1_18
-- Use analytic function to get moving average2:
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 4 PRECEDING AND CURRENT ROW)ma2_4
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 6 PRECEDING AND CURRENT ROW)ma2_6
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 8 PRECEDING AND CURRENT ROW)ma2_8
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 9 PRECEDING AND CURRENT ROW)ma2_9
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12 PRECEDING AND CURRENT ROW)ma2_12
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 18 PRECEDING AND CURRENT ROW)ma2_18
-- Get future ydates
,LEAD(ydate,4,NULL)OVER(PARTITION BY pair ORDER BY ydate) ydate4
,LEAD(ydate,6,NULL)OVER(PARTITION BY pair ORDER BY ydate) ydate6
,LEAD(ydate,8,NULL)OVER(PARTITION BY pair ORDER BY ydate) ydate8
-- Relative to current-row, get future closing prices:
,LEAD(clse,4,NULL)OVER(PARTITION BY pair ORDER BY ydate) clse4
,LEAD(clse,6,NULL)OVER(PARTITION BY pair ORDER BY ydate) clse6
,LEAD(clse,8,NULL)OVER(PARTITION BY pair ORDER BY ydate) clse8
FROM h15c
WHERE ydate >'2009-01-01'
-- Prevent divide by zero:
AND clse > 0
ORDER BY ydate
/

-- I derive "normalized" slope of moving-averages.
-- I normalize them to help me compare JPY pairs to all the other pairs:
CREATE OR REPLACE VIEW v468hma12 AS
SELECT
pair
,ydate
,(ma2_4 - ma1_4)/ma1_4 ma4_slope
,(ma2_6 - ma1_6)/ma1_6 ma6_slope
,(ma2_8 - ma1_8)/ma1_8 ma8_slope
,(ma2_9 - ma1_9)/ma1_9 ma9_slope
,(ma2_12 - ma1_12)/ma1_12 ma12_slope
,(ma2_18 - ma1_18)/ma1_18 ma18_slope
,ydate4
,ydate6
,ydate8
,clse4
,clse6
,clse8
-- I collect normalized gains too:
,(clse4 - clse)/clse npg4
,(clse6 - clse)/clse npg6
,(clse8 - clse)/clse npg8
FROM v468hma10
ORDER BY ydate
/

-- Now that I have ma-slopes, I calculate stddev of their distributions:

CREATE OR REPLACE VIEW v468hma AS
SELECT
pair
,ydate
,ma4_slope
,ma6_slope
,ma8_slope
,ma9_slope
,ma12_slope
,ma18_slope
,npg4
,npg6
,npg8
,STDDEV(ma4_slope)OVER(PARTITION BY pair)stddev4
,STDDEV(ma6_slope)OVER(PARTITION BY pair)stddev6
,STDDEV(ma8_slope)OVER(PARTITION BY pair)stddev8
-- Sign of slope is a useful attribute:
,SIGN(ma4_slope)sgn4
,SIGN(ma6_slope)sgn6
,SIGN(ma8_slope)sgn8
FROM v468hma12
ORDER BY ydate
/

-- Now, I have all the data I need.
-- Start by looking at CORR() between ma-slope and gain:

-- Is ma_slope correlated with npg4?
COLUMN pair FORMAT A7

SELECT 
pair
,COUNT(npg4)
,ROUND(CORR(ma4_slope,npg4),2)corr4
,ROUND(CORR(ma6_slope,npg4),2)corr6
,ROUND(CORR(ma8_slope,npg4),2)corr8
,ROUND(CORR(ma9_slope,npg4),2)corr9
,ROUND(CORR(ma12_slope,npg4),2)corr12
,ROUND(CORR(ma18_slope,npg4),2)corr18
FROM v468hma
GROUP BY pair
ORDER BY pair
/

-- Is ma_slope correlated with npg6?
SELECT 
pair
,COUNT(npg6)
,ROUND(CORR(ma4_slope,npg6),2)corr4
,ROUND(CORR(ma6_slope,npg6),2)corr6
,ROUND(CORR(ma8_slope,npg6),2)corr8
,ROUND(CORR(ma9_slope,npg6),2)corr9
,ROUND(CORR(ma12_slope,npg6),2)corr12
,ROUND(CORR(ma18_slope,npg6),2)corr18
FROM v468hma
GROUP BY pair
ORDER BY pair
/

-- Is ma_slope correlated with npg8?
SELECT 
pair
,COUNT(npg8)
,ROUND(CORR(ma4_slope,npg8),2)corr4
,ROUND(CORR(ma6_slope,npg8),2)corr6
,ROUND(CORR(ma8_slope,npg8),2)corr8
,ROUND(CORR(ma9_slope,npg8),2)corr9
,ROUND(CORR(ma12_slope,npg8),2)corr12
,ROUND(CORR(ma18_slope,npg8),2)corr18
FROM v468hma
GROUP BY pair
ORDER BY pair
/

-- Now look at very steep ma-slopes and associated gains:

-- stddev4, npg4:
SELECT * FROM
(
  SELECT
  sgn4
  ,pair
  ,AVG(npg4)avg_npg4
  ,CORR(ma4_slope,npg4)crr44
  ,COUNT(ydate)
  ,MIN(ydate)
  ,MAX(ydate)
  FROM v468hma
  WHERE ABS(ma4_slope) > 2.1*stddev4
  GROUP BY sgn4,pair
  ORDER BY sgn4,pair
)
WHERE ABS(avg_npg4) > 4 * 0.0002
AND sgn4 * avg_npg4 * crr44 > 0
AND crr44 < 0
/

-- stddev6, npg4:
SELECT * FROM
(
  SELECT
  sgn6
  ,pair
  ,AVG(npg4)avg_npg4
  ,CORR(ma6_slope,npg4)crr64
  ,COUNT(ydate)
  ,MIN(ydate)
  ,MAX(ydate)
  FROM v468hma
  WHERE ABS(ma6_slope) > 2.1*stddev6
  GROUP BY sgn6,pair
  ORDER BY sgn6,pair
)
WHERE ABS(avg_npg4) > 4 * 0.0002
AND sgn6 * avg_npg4 * crr64 > 0
AND crr64 < 0
/

-- stddev8, npg4:
SELECT * FROM
(
  SELECT
  sgn8
  ,pair
  ,AVG(npg4)avg_npg4
  ,CORR(ma8_slope,npg4)crr84
  ,COUNT(ydate)
  ,MIN(ydate)
  ,MAX(ydate)
  FROM v468hma
  WHERE ABS(ma8_slope) > 2.1*stddev8
  GROUP BY sgn8,pair
  ORDER BY sgn8,pair
)
WHERE ABS(avg_npg4) > 4 * 0.0002
AND sgn8 * avg_npg4 * crr84 > 0
AND crr84 < 0
/

-- stddev6, npg6:
SELECT * FROM
(
  SELECT
  sgn6
  ,pair
  ,AVG(npg6)avg_npg6
  ,CORR(ma6_slope,npg6)crr66
  ,COUNT(ydate)
  ,MIN(ydate)
  ,MAX(ydate)
  FROM v468hma
  WHERE ABS(ma6_slope) > 2.1*stddev6
  GROUP BY sgn6,pair
  ORDER BY sgn6,pair
)
WHERE ABS(avg_npg6) > 9 * 0.0001
AND sgn6 * avg_npg6 * crr66 > 0
/

-- stddev8, npg6:
SELECT * FROM
(
  SELECT
  sgn8
  ,pair
  ,AVG(npg6)avg_npg6
  ,CORR(ma8_slope,npg6)crr86
  ,COUNT(ydate)
  ,MIN(ydate)
  ,MAX(ydate)
  FROM v468hma
  WHERE ABS(ma8_slope) > 2.1*stddev8
  GROUP BY sgn8,pair
  ORDER BY sgn8,pair
)
WHERE ABS(avg_npg6) > 9 * 0.0001
AND sgn8 * avg_npg6 * crr86 > 0
/

exit
