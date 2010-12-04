--
-- t12.sql
--

-- I use this script to look at Forex data which has a 10 minute duration between each datapoint.

SET LINES 66
DESC dukas10min
SET LINES 166

SELECT
pair
,MIN(ydate)
,COUNT(*)
,MAX(ydate)
FROM dukas10min
GROUP BY pair
ORDER BY pair
/


CREATE OR REPLACE VIEW tr10 AS
SELECT
pair
-- ydate is granular down to 10 min:
,ydate
,clse
-- Use analytic function to get moving average1:
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 5 PRECEDING AND 1 PRECEDING)ma1_4
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 10 PRECEDING AND 2 PRECEDING)ma1_8
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 20 PRECEDING AND 4 PRECEDING)ma1_16
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 40 PRECEDING AND 8 PRECEDING)ma1_32
-- Use analytic function to get moving average2:
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 4 PRECEDING AND CURRENT ROW)ma2_4
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 8 PRECEDING AND CURRENT ROW)ma2_8
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 16 PRECEDING AND CURRENT ROW)ma2_16
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 32 PRECEDING AND CURRENT ROW)ma2_32
-- Relative to current-row, get future closing prices:
,LEAD(clse,4,NULL)OVER(PARTITION BY pair ORDER BY ydate) clse4
,LEAD(clse,6,NULL)OVER(PARTITION BY pair ORDER BY ydate) clse6
,LEAD(clse,8,NULL)OVER(PARTITION BY pair ORDER BY ydate) clse8
FROM dukas10min
-- Prevent divide by zero:
WHERE clse > 0
ORDER BY pair,ydate
/

-- I derive "normalized" slope of moving-averages.
-- I normalize them to help me compare JPY pairs to all the other pairs.
-- I collect normalized gains too:

CREATE OR REPLACE VIEW tr12 AS
SELECT
pair
,ydate
,clse
-- Derive normalized mvg-avg-slope:
,(ma2_4 - ma1_4)/ma1_4 ma4_slope
,(ma2_8 - ma1_8)/ma1_8 ma8_slope
,(ma2_16 - ma1_16)/ma1_16 ma16_slope
,(ma2_32 - ma1_32)/ma1_32 ma32_slope
-- I collect normalized gains too:
,(clse4-clse)/clse npg4
,(clse6-clse)/clse npg6
,(clse8-clse)/clse npg8
FROM tr10
-- prevent divide by 0:
WHERE(ma1_4*ma1_8*ma1_16*ma1_32)!=0
ORDER BY pair,ydate
/

-- Now that I have ma-slopes, I calculate stddev of their distributions.
-- Also I get lagging npgs and sgn:

DROP TABLE tr14;
PURGE RECYCLEBIN;
CREATE TABLE tr14 COMPRESS AS
-- CREATE OR REPLACE VIEW tr14 AS
SELECT
pair
,ydate
,clse
,ma4_slope
,ma8_slope
,ma16_slope
,ma32_slope
,npg4
,npg6
,npg8
,STDDEV(ma4_slope)OVER(PARTITION BY pair)ma_stddev4
,STDDEV(ma8_slope)OVER(PARTITION BY pair)ma_stddev8
,STDDEV(ma16_slope)OVER(PARTITION BY pair)ma_stddev16
,STDDEV(ma32_slope)OVER(PARTITION BY pair)ma_stddev32
-- Sign of slope is a useful attribute:
,SIGN(ma4_slope)sgn4
,SIGN(ma8_slope)sgn8
,SIGN(ma16_slope)sgn16
,SIGN(ma32_slope)sgn32
-- Get npg from the past:
,LAG(npg4,5,NULL)OVER(PARTITION BY pair ORDER BY ydate)npg4lg
,LAG(npg6,7,NULL)OVER(PARTITION BY pair ORDER BY ydate)npg6lg
,LAG(npg8,9,NULL)OVER(PARTITION BY pair ORDER BY ydate)npg8lg
FROM tr12
ORDER BY pair,ydate
/

-- rpt
SELECT
pair
,MIN(ydate)
,COUNT(ydate)
,MAX(ydate)
FROM tr14
GROUP BY pair
ORDER BY pair
/

-- Do a simple query which looks for CORR() tween npg_lg and npg where npg_lg is lucrative.

-- Look at npg4lg 1st:
COLUMN avg_npg FORMAT 9.9999
COLUMN sgn4 FORMAT 9999
COLUMN sgn8 FORMAT 9999
COLUMN sgn16 FORMAT 99999
COLUMN sgn32 FORMAT 99999
COLUMN cnt   FORMAT 99999

SELECT
COUNT(pair)cnt
,pair
,ROUND(AVG(-sgn4*npg4),4)avg_npg
,sgn4
,sgn8
,sgn16
,sgn32
,ROUND(CORR(npg4lg,npg4),2)crr44
,ROUND(CORR(npg6lg,npg6),2)crr66
,ROUND(CORR(npg8lg,npg8),2)crr88
FROM tr14
-- Look at npg4 1st:
WHERE ABS(npg4lg) > 0.0004
AND sgn4*sgn8*sgn16*sgn32 !=0
GROUP BY
pair
,sgn4
,sgn8
,sgn16
,sgn32
HAVING COUNT(pair)>11
ORDER BY
pair
,sgn4
,sgn8
,sgn16
,sgn32
/


EXIT
