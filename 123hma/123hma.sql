--
-- 123hma.sql
--

-- I use this script to help me answer the question,
-- Is moving average slope predictive?

CREATE OR REPLACE VIEW v123hma10 AS
SELECT
pair
-- ydate is granular down to the hour:
,ydate
,clse
-- Use analytic function to get moving average1:
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 2 PRECEDING AND 1 PRECEDING)ma1_1
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 3 PRECEDING AND 1 PRECEDING)ma1_2
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 4 PRECEDING AND 1 PRECEDING)ma1_3
-- Use analytic function to get moving average2:
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 1 PRECEDING AND CURRENT ROW)ma2_1
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)ma2_2
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 3 PRECEDING AND CURRENT ROW)ma2_3
-- Get future ydates
,LEAD(ydate,1,NULL)OVER(PARTITION BY pair ORDER BY ydate) ydate1
,LEAD(ydate,2,NULL)OVER(PARTITION BY pair ORDER BY ydate) ydate2
,LEAD(ydate,3,NULL)OVER(PARTITION BY pair ORDER BY ydate) ydate3
-- Relative to current-row, get future closing prices:
,LEAD(clse,1,NULL)OVER(PARTITION BY pair ORDER BY ydate) clse1
,LEAD(clse,2,NULL)OVER(PARTITION BY pair ORDER BY ydate) clse2
,LEAD(clse,3,NULL)OVER(PARTITION BY pair ORDER BY ydate) clse3
FROM hourly 
WHERE ydate >'2009-01-01'
-- Prevent divide by zero:
AND opn > 0
-- Focus on aud_usd for now:
ORDER BY ydate
/

-- I should see 6 x 3:
SELECT pair,COUNT(*)FROM v123hma10 WHERE ydate3 IS NULL GROUP BY pair;
-- I should see 6 x 3:
SELECT pair,COUNT(*)FROM v123hma10 WHERE clse3 IS NULL GROUP BY pair;

-- I derive slope of moving-averages:
CREATE OR REPLACE VIEW v123hma AS
SELECT
pair
,ydate
,(ma2_1 - ma1_1)ma1_slope
,(ma2_2 - ma1_2)ma2_slope
,(ma2_3 - ma1_3)ma3_slope
,ydate1
,ydate2
,ydate3
,clse1
,clse2
,clse3
,(clse1 - clse)/clse npg1
,(clse2 - clse)/clse npg2
,(clse3 - clse)/clse npg3
FROM v123hma10
ORDER BY ydate
/

-- Is ma_slope correlated with npg1?:
COLUMN pair FORMAT A7

SELECT 
pair
,COUNT(npg1)
,ROUND(CORR(ma1_slope,npg1),2)corr1
,ROUND(CORR(ma2_slope,npg1),2)corr2
,ROUND(CORR(ma3_slope,npg1),2)corr3
FROM v123hma
GROUP BY pair
ORDER BY pair
/

-- Is ma_slope correlated with npg2?:

SELECT 
pair
,COUNT(npg2)
,ROUND(CORR(ma1_slope,npg2),2)corr1
,ROUND(CORR(ma2_slope,npg2),2)corr2
,ROUND(CORR(ma3_slope,npg2),2)corr3
FROM v123hma
GROUP BY pair
ORDER BY pair
/

-- Look at ma1_slope and npg1,2,3:
SELECT
pair
,nt74
,AVG(ma1_slope)avg_ma1s
,AVG(npg1)avg_npg1
,AVG(npg2)avg_npg2
,AVG(npg3)avg_npg3
,COUNT(pair)
,STDDEV(npg1)stddev_npg1
FROM
(
  SELECT
  pair
  ,NTILE(7) OVER (PARTITION BY pair ORDER BY (ma1_slope))nt74
  ,ma1_slope
  ,npg1,npg2,npg3
  FROM v123hma
)
GROUP BY pair,nt74
ORDER BY pair,nt74
/


-- Look at ma2_slope and npg1,2,3:
SELECT
pair
,nt74
,AVG(ma2_slope)avg_ma2s
,AVG(npg1)avg_npg1
,AVG(npg2)avg_npg2
,AVG(npg3)avg_npg3
,COUNT(pair)
,STDDEV(npg1)stddev_npg1
FROM
(
  SELECT
  pair
  ,NTILE(7) OVER (PARTITION BY pair ORDER BY (ma2_slope))nt74
  ,ma2_slope
  ,npg1,npg2,npg3
  FROM v123hma
)
GROUP BY pair,nt74
ORDER BY pair,nt74
/

exit
