--
-- t10.sql
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
-- I normalize them to help me compare JPY pairs to all the other pairs:

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

-- Now that I have ma-slopes, I calculate stddev of their distributions:

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
FROM tr12
ORDER BY pair,ydate
/

-- I have what I need, now I report.
-- Start with mellow slopes:

-- ma4, npg4:
SELECT
sgn4
,pair
,ROUND(AVG(npg4),6)avg_npg4
,COUNT(pair)
FROM tr14
WHERE ABS(ma4_slope)BETWEEN 0.4*ma_stddev4 AND 1.1*ma_stddev4
GROUP BY sgn4,pair
ORDER BY sgn4,pair
/

-- ma8, npg4:
SELECT
sgn8
,pair
,ROUND(AVG(npg4),6)avg_npg4
,COUNT(pair)
FROM tr14
WHERE ABS(ma8_slope)BETWEEN 0.4*ma_stddev8 AND 1.1*ma_stddev8
GROUP BY sgn8,pair
ORDER BY sgn8,pair
/

-- ma16, npg4:
SELECT
sgn16
,pair
,ROUND(AVG(npg4),6)avg_npg4
,COUNT(pair)
FROM tr14
WHERE ABS(ma16_slope)BETWEEN 0.4*ma_stddev16 AND 1.1*ma_stddev16
GROUP BY sgn16,pair
ORDER BY sgn16,pair
/

-- ma32, npg4:
SELECT
sgn32
,pair
,ROUND(AVG(npg4),6)avg_npg4
,COUNT(pair)
FROM tr14
WHERE ABS(ma32_slope)BETWEEN 0.4*ma_stddev32 AND 1.1*ma_stddev32
GROUP BY sgn32,pair
ORDER BY sgn32,pair
/


-- ma8, npg6:
SELECT
sgn8
,pair
,ROUND(AVG(npg6),6)avg_npg6
,COUNT(pair)
FROM tr14
WHERE ABS(ma8_slope)BETWEEN 0.4*ma_stddev8 AND 1.1*ma_stddev8
GROUP BY sgn8,pair
ORDER BY sgn8,pair
/

-- ma16, npg6:
SELECT
sgn16
,pair
,ROUND(AVG(npg6),6)avg_npg6
,COUNT(pair)
FROM tr14
WHERE ABS(ma16_slope)BETWEEN 0.4*ma_stddev16 AND 1.1*ma_stddev16
GROUP BY sgn16,pair
ORDER BY sgn16,pair
/

-- ma32, npg6:
SELECT
sgn32
,pair
,ROUND(AVG(npg6),6)avg_npg6
,COUNT(pair)
FROM tr14
WHERE ABS(ma32_slope)BETWEEN 0.4*ma_stddev32 AND 1.1*ma_stddev32
GROUP BY sgn32,pair
ORDER BY sgn32,pair
/



-- ma8, npg8:
SELECT
sgn8
,pair
,ROUND(AVG(npg8),6)avg_npg8
,COUNT(pair)
FROM tr14
WHERE ABS(ma8_slope)BETWEEN 0.4*ma_stddev8 AND 1.1*ma_stddev8
GROUP BY sgn8,pair
ORDER BY sgn8,pair
/

-- ma16, npg8:
SELECT
sgn16
,pair
,ROUND(AVG(npg8),6)avg_npg8
,COUNT(pair)
FROM tr14
WHERE ABS(ma16_slope)BETWEEN 0.4*ma_stddev16 AND 1.1*ma_stddev16
GROUP BY sgn16,pair
ORDER BY sgn16,pair
/

-- ma32, npg8:
SELECT
sgn32
,pair
,ROUND(AVG(npg8),6)avg_npg8
,COUNT(pair)
FROM tr14
WHERE ABS(ma32_slope)BETWEEN 0.4*ma_stddev32 AND 1.1*ma_stddev32
GROUP BY sgn32,pair
ORDER BY sgn32,pair
/

-- Now look at steep slopes:

-- ma4, npg4:
SELECT
sgn4
,pair
,ROUND(AVG(npg4),6)avg_npg4
,COUNT(pair)
FROM tr14
WHERE ABS(ma4_slope) > 2.0*ma_stddev4
GROUP BY sgn4,pair
ORDER BY sgn4,pair
/

-- ma8, npg4:
SELECT
sgn8
,pair
,ROUND(AVG(npg4),6)avg_npg4
,COUNT(pair)
FROM tr14
WHERE ABS(ma8_slope) > 2.0*ma_stddev8
GROUP BY sgn8,pair
ORDER BY sgn8,pair
/

-- ma16, npg4:
SELECT
sgn16
,pair
,ROUND(AVG(npg4),6)avg_npg4
,COUNT(pair)
FROM tr14
WHERE ABS(ma16_slope) > 2.0*ma_stddev16
GROUP BY sgn16,pair
ORDER BY sgn16,pair
/

-- ma32, npg4:
SELECT
sgn32
,pair
,ROUND(AVG(npg4),6)avg_npg4
,COUNT(pair)
FROM tr14
WHERE ABS(ma32_slope) > 2.0*ma_stddev32
GROUP BY sgn32,pair
ORDER BY sgn32,pair
/


-- ma8, npg6:
SELECT
sgn8
,pair
,ROUND(AVG(npg6),6)avg_npg6
,COUNT(pair)
FROM tr14
WHERE ABS(ma8_slope) > 2.0*ma_stddev8
GROUP BY sgn8,pair
ORDER BY sgn8,pair
/

-- ma16, npg6:
SELECT
sgn16
,pair
,ROUND(AVG(npg6),6)avg_npg6
,COUNT(pair)
FROM tr14
WHERE ABS(ma16_slope) > 2.0*ma_stddev16
GROUP BY sgn16,pair
ORDER BY sgn16,pair
/

-- ma32, npg6:
SELECT
sgn32
,pair
,ROUND(AVG(npg6),6)avg_npg6
,COUNT(pair)
FROM tr14
WHERE ABS(ma32_slope) > 2.0*ma_stddev32
GROUP BY sgn32,pair
ORDER BY sgn32,pair
/



-- ma8, npg8:
SELECT
sgn8
,pair
,ROUND(AVG(npg8),6)avg_npg8
,COUNT(pair)
FROM tr14
WHERE ABS(ma8_slope) > 2.0*ma_stddev8
GROUP BY sgn8,pair
ORDER BY sgn8,pair
/

-- ma16, npg8:
SELECT
sgn16
,pair
,ROUND(AVG(npg8),6)avg_npg8
,COUNT(pair)
FROM tr14
WHERE ABS(ma16_slope) > 2.0*ma_stddev16
GROUP BY sgn16,pair
ORDER BY sgn16,pair
/

-- ma32, npg8:
SELECT
sgn32
,pair
,ROUND(AVG(npg8),6)avg_npg8
,COUNT(pair)
FROM tr14
WHERE ABS(ma32_slope) > 2.0*ma_stddev32
GROUP BY sgn32,pair
ORDER BY sgn32,pair
/


-- ma4, npg4:
SELECT
sgn4
,pair
,ROUND(AVG(npg4),6)avg_npg4
,COUNT(pair)
FROM tr14
WHERE ABS(ma4_slope) > 3.0*ma_stddev4
GROUP BY sgn4,pair
ORDER BY sgn4,pair
/

-- ma8, npg8:
SELECT
sgn8
,pair
,ROUND(AVG(npg8),6)avg_npg8
,COUNT(pair)
FROM tr14
WHERE ABS(ma8_slope) > 3.0*ma_stddev8
GROUP BY sgn8,pair
ORDER BY sgn8,pair
/


-- ma16, npg8:
SELECT
sgn16
,pair
,ROUND(AVG(npg8),6)avg_npg8
,COUNT(pair)
FROM tr14
WHERE ABS(ma16_slope) > 3.0*ma_stddev16
GROUP BY sgn16,pair
ORDER BY sgn16,pair
/

-- ma32, npg8:
SELECT
sgn32
,pair
,ROUND(AVG(npg8),6)avg_npg8
,COUNT(pair)
FROM tr14
WHERE ABS(ma32_slope) > 3.0*ma_stddev32
GROUP BY sgn32,pair
ORDER BY sgn32,pair
/



EXIT
