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
,opn
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
,LEAD(clse,3,NULL)OVER(PARTITION BY pair ORDER BY ydate) clse4
,LEAD(clse,5,NULL)OVER(PARTITION BY pair ORDER BY ydate) clse6
,LEAD(clse,7,NULL)OVER(PARTITION BY pair ORDER BY ydate) clse8
FROM hourly 
WHERE ydate >'2009-01-01'
-- Prevent divide by zero:
AND opn > 0
-- Focus on aud_usd for now:
ORDER BY ydate
/



-- I should see 6 x 6:
SELECT pair,COUNT(*)FROM v468hma10 WHERE ydate6 IS NULL GROUP BY pair;
-- I should see 6 x 5:
SELECT pair,COUNT(*)FROM v468hma10 WHERE clse6 IS NULL GROUP BY pair;

-- I derive slope of moving-averages:
CREATE OR REPLACE VIEW v468hma AS
SELECT
pair
,ydate
,(ma2_4 - ma1_4)ma4_slope
,(ma2_6 - ma1_6)ma6_slope
,(ma2_8 - ma1_8)ma8_slope
,(ma2_9 - ma1_9)ma9_slope
,(ma2_12 - ma1_12)ma12_slope
,(ma2_18 - ma1_18)ma18_slope
,ydate4
,ydate6
,ydate8
,clse4
,clse6
,clse8
,(clse4 - opn)/opn npg4
,(clse6 - opn)/opn npg6
,(clse8 - opn)/opn npg8
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

exit
