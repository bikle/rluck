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

-- I should see 6 x 6:
SELECT pair,COUNT(*)FROM v468hma10 WHERE ydate6 IS NULL GROUP BY pair;
-- I should see 6 x 6:
SELECT pair,COUNT(*)FROM v468hma10 WHERE clse6 IS NULL GROUP BY pair;

-- I derive "normalized" slope of moving-averages:
CREATE OR REPLACE VIEW v468hma AS
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
,(clse4 - clse)/clse npg4
,(clse6 - clse)/clse npg6
,(clse8 - clse)/clse npg8
FROM v468hma10
ORDER BY ydate
/

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


-- Look at ma4_slope and npg4,6,8:
SELECT
pair
,nt74
,AVG(ma4_slope)avg_ma4s
,AVG(npg4)avg_npg4
,AVG(npg6)avg_npg6
,AVG(npg8)avg_npg8
,COUNT(pair)
,STDDEV(npg4)stddev_npg4
FROM
(
  SELECT
  pair
  ,NTILE(7) OVER (PARTITION BY pair ORDER BY (ma4_slope))nt74
  ,ma4_slope
  ,npg4,npg6,npg8
  FROM v468hma
)
GROUP BY pair,nt74
ORDER BY pair,nt74
/


-- Look at ma8_slope and npg4,6,8:
SELECT
pair
,nt74
,AVG(ma8_slope)avg_ma8s
,AVG(npg4)avg_npg4
,AVG(npg6)avg_npg6
,AVG(npg8)avg_npg8
,COUNT(pair)
,STDDEV(npg4)stddev_npg4
FROM
(
  SELECT
  pair
  ,NTILE(7) OVER (PARTITION BY pair ORDER BY (ma8_slope))nt74
  ,ma8_slope
  ,npg4,npg6,npg8
  FROM v468hma
)
GROUP BY pair,nt74
ORDER BY pair,nt74
/


-- Instead of using NTILE() to categorize ma-slope,
-- I use 3 std-deviations ma-slope.


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
,(clse4 - clse)/clse npg4
,(clse6 - clse)/clse npg6
,(clse8 - clse)/clse npg8
FROM v468hma10
ORDER BY ydate
/

CREATE OR REPLACE VIEW v468hma14 AS
SELECT
pair
,ydate
,ma4_slope
,ma6_slope
,ma8_slope
,ma9_slope
,ma12_slope
,ma18_slope
,ydate4
,ydate6
,ydate8
,clse4
,clse6
,clse8
,npg4
,npg6
,npg8
,STDDEV(ma4_slope)OVER(PARTITION BY pair)stddev4
,STDDEV(ma6_slope)OVER(PARTITION BY pair)stddev6
,STDDEV(ma8_slope)OVER(PARTITION BY pair)stddev8
,SIGN(ma4_slope)sgn4
,SIGN(ma6_slope)sgn6
,SIGN(ma8_slope)sgn8
FROM v468hma12
ORDER BY ydate
/

--rpt
-- I should see min as the same as max:
SELECT
pair
,MIN(stddev4),MAX(stddev4)
,MIN(stddev6),MAX(stddev6)
,MIN(stddev8),MAX(stddev8)
FROM v468hma14
GROUP BY pair
/

-- Look at steep slopes:
CREATE OR REPLACE VIEW v468hma16 AS
SELECT
pair
,ydate
,ma4_slope
,ma6_slope
,ma8_slope
,ma9_slope
,ma12_slope
,ma18_slope
,ydate4
,ydate6
,ydate8
,clse4
,clse6
,clse8
,npg4
,npg6
,npg8
,sgn4
,sgn6
,sgn8
,STDDEV(ma4_slope)OVER(PARTITION BY pair)stddev4
,STDDEV(ma6_slope)OVER(PARTITION BY pair)stddev6
,STDDEV(ma8_slope)OVER(PARTITION BY pair)stddev8
FROM v468hma14
ORDER BY ydate
/


-- npg4, stddev4:
SELECT
sgn4
,pair
,AVG(npg4)
,CORR(ma4_slope,npg4)crr4
,COUNT(ydate)
,MIN(ydate)
,MAX(ydate)
FROM v468hma14
WHERE ABS(ma4_slope) > 2.1*stddev4
GROUP BY sgn4,pair
ORDER BY sgn4,pair
/

-- npg4, stddev6:
SELECT
sgn6
,pair
,AVG(npg4)
,CORR(ma6_slope,npg4)crr4
,COUNT(ydate)
,MIN(ydate)
,MAX(ydate)
FROM v468hma14
WHERE ABS(ma6_slope) > 2.1*stddev6
GROUP BY sgn6,pair
ORDER BY sgn6,pair
/

-- npg4, stddev8:
SELECT
sgn8
,pair
,AVG(npg4)
,CORR(ma8_slope,npg4)crr4
,COUNT(ydate)
,MIN(ydate)
,MAX(ydate)
FROM v468hma14
WHERE ABS(ma8_slope) > 2.1*stddev8
GROUP BY sgn8,pair
ORDER BY sgn8,pair
/

-- npg6, stddev6:
SELECT
sgn6
,pair
,AVG(npg6)
,CORR(ma6_slope,npg6)crr6
,COUNT(ydate)
,MIN(ydate)
,MAX(ydate)
FROM v468hma14
WHERE ABS(ma6_slope) > 2.1*stddev6
GROUP BY sgn6,pair
ORDER BY sgn6,pair
/

-- npg6, stddev8:
SELECT
sgn8
,pair
,AVG(npg6)
,CORR(ma8_slope,npg6)crr6
,COUNT(ydate)
,MIN(ydate)
,MAX(ydate)
FROM v468hma14
WHERE ABS(ma8_slope) > 2.1*stddev8
GROUP BY sgn8,pair
ORDER BY sgn8,pair
/

exit
