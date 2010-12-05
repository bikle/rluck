--
-- c10.sql
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
-- Also I get sgn:

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
,STDDEV(ma4_slope)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 200 PRECEDING AND CURRENT ROW)ma_stddev4
,STDDEV(ma8_slope)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 200 PRECEDING AND CURRENT ROW)ma_stddev8
,STDDEV(ma16_slope)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 200 PRECEDING AND CURRENT ROW)ma_stddev16
,STDDEV(ma32_slope)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 200 PRECEDING AND CURRENT ROW)ma_stddev32
-- Sign of slope is a useful attribute:
,SIGN(ma4_slope)sgn4
,SIGN(ma8_slope)sgn8
,SIGN(ma16_slope)sgn16
,SIGN(ma32_slope)sgn32
FROM tr12
ORDER BY pair,ydate
/

-- Now get rows with mellow slopes for ma32:

CREATE OR REPLACE VIEW tr16 AS
SELECT
pair
,ydate
,npg4
,npg6
,npg8
,sgn32
FROM tr14
-- I want mellow slopes:
WHERE ABS(ma32_slope)BETWEEN 0.5*ma_stddev32 AND 1.2*ma_stddev32
ORDER BY pair,ydate
/

-- Now get future rows:

CREATE OR REPLACE VIEW tr162 AS
SELECT
pair
,ydate
,npg4
,npg6
,npg8
,sgn32
,LEAD(ydate,1,NULL)OVER(PARTITION BY pair ORDER BY ydate)ydate_ld
,LEAD(npg4,1,NULL)OVER(PARTITION BY pair ORDER BY ydate)npg4_ld
,LEAD(npg6,1,NULL)OVER(PARTITION BY pair ORDER BY ydate)npg6_ld
,LEAD(npg8,1,NULL)OVER(PARTITION BY pair ORDER BY ydate)npg8_ld
FROM tr16
ORDER BY pair,ydate
/

-- Look at both npg4 and npg4_ld

SELECT
pair
,sgn32
,ROUND(sgn32 * AVG(npg4),4)sgn32_x_npg4
,ROUND(sgn32 * AVG(npg4_ld),4)sgn32_x_npg4_ld
,COUNT(pair)cnt
FROM
(
  SELECT
  pair
  ,npg4
  ,sgn32
  ,npg4_ld
  FROM tr162
  WHERE ydate_ld BETWEEN ydate + 50/60/24 AND ydate + 400/60/24
)
WHERE sgn32 * npg4 > 0.0012
GROUP BY pair,sgn32
ORDER BY pair,sgn32
/

-- Look at both npg6 and npg6_ld

SELECT
pair
,sgn32
,ROUND(sgn32 * AVG(npg6),4)sgn32_x_npg6
,ROUND(sgn32 * AVG(npg6_ld),4)sgn32_x_npg6_ld
,COUNT(pair)cnt
FROM
(
  SELECT
  pair
  ,npg6
  ,sgn32
  ,npg6_ld
  FROM tr162
  WHERE ydate_ld BETWEEN ydate + 70/60/24 AND ydate + 600/60/24
)
WHERE sgn32 * npg6 > 0.0016
GROUP BY pair,sgn32
ORDER BY pair,sgn32
/


-- Look at both npg8 and npg8_ld

SELECT
pair
,sgn32
,ROUND(sgn32 * AVG(npg8),4)sgn32_x_npg8
,ROUND(sgn32 * AVG(npg8_ld),4)sgn32_x_npg8_ld
,COUNT(pair)cnt
FROM
(
  SELECT
  pair
  ,npg8
  ,sgn32
  ,npg8_ld
  FROM tr162
  WHERE ydate_ld BETWEEN ydate + 90/60/24 AND ydate + 800/60/24
)
WHERE sgn32 * npg8 > 0.0021
GROUP BY pair,sgn32
ORDER BY pair,sgn32
/


-- Now get rows with mellow slopes for ma16:

CREATE OR REPLACE VIEW tr16 AS
SELECT
pair
,ydate
,npg4
,npg6
,npg8
,sgn16
FROM tr14
-- I want mellow slopes:
WHERE ABS(ma16_slope)BETWEEN 0.5*ma_stddev16 AND 1.2*ma_stddev16
ORDER BY pair,ydate
/

-- Now get future rows:

CREATE OR REPLACE VIEW tr162 AS
SELECT
pair
,ydate
,npg4
,npg6
,npg8
,sgn16
,LEAD(ydate,1,NULL)OVER(PARTITION BY pair ORDER BY ydate)ydate_ld
,LEAD(npg4,1,NULL)OVER(PARTITION BY pair ORDER BY ydate)npg4_ld
,LEAD(npg6,1,NULL)OVER(PARTITION BY pair ORDER BY ydate)npg6_ld
,LEAD(npg8,1,NULL)OVER(PARTITION BY pair ORDER BY ydate)npg8_ld
FROM tr16
ORDER BY pair,ydate
/


-- Look at both npg4 and npg4_ld

SELECT
pair
,sgn16
,ROUND(sgn16 * AVG(npg4),4)sgn16_x_npg4
,ROUND(sgn16 * AVG(npg4_ld),4)sgn16_x_npg4_ld
,COUNT(pair)cnt
FROM
(
  SELECT
  pair
  ,npg4
  ,sgn16
  ,npg4_ld
  FROM tr162
  WHERE ydate_ld BETWEEN ydate + 50/60/24 AND ydate + 400/60/24
)
WHERE sgn16 * npg4 > 0.0010
GROUP BY pair,sgn16
ORDER BY pair,sgn16
/


-- Look at both npg6 and npg6_ld

SELECT
pair
,sgn16
,ROUND(sgn16 * AVG(npg6),4)sgn16_x_npg6
,ROUND(sgn16 * AVG(npg6_ld),4)sgn16_x_npg6_ld
,COUNT(pair)cnt
FROM
(
  SELECT
  pair
  ,npg6
  ,sgn16
  ,npg6_ld
  FROM tr162
  WHERE ydate_ld BETWEEN ydate + 70/60/24 AND ydate + 600/60/24
)
WHERE sgn16 * npg6 > 0.0011
GROUP BY pair,sgn16
ORDER BY pair,sgn16
/


-- Look at both npg8 and npg8_ld

SELECT
pair
,sgn16
,ROUND(sgn16 * AVG(npg8),4)sgn16_x_npg8
,ROUND(sgn16 * AVG(npg8_ld),4)sgn16_x_npg8_ld
,COUNT(pair)cnt
FROM
(
  SELECT
  pair
  ,npg8
  ,sgn16
  ,npg8_ld
  FROM tr162
  WHERE ydate_ld BETWEEN ydate + 90/60/24 AND ydate + 900/60/24
)
WHERE sgn16 * npg8 > 0.0011
GROUP BY pair,sgn16
ORDER BY pair,sgn16
/


-- Now get rows with mellow slopes for ma8:

CREATE OR REPLACE VIEW tr16 AS
SELECT
pair
,ydate
,npg4
,npg6
,npg8
,sgn8
FROM tr14
-- I want mellow slopes:
WHERE ABS(ma8_slope)BETWEEN 0.5*ma_stddev8 AND 1.2*ma_stddev8
ORDER BY pair,ydate
/

-- Now get future rows:

CREATE OR REPLACE VIEW tr162 AS
SELECT
pair
,ydate
,npg4
,npg6
,npg8
,sgn8
,LEAD(ydate,1,NULL)OVER(PARTITION BY pair ORDER BY ydate)ydate_ld
,LEAD(npg4,1,NULL)OVER(PARTITION BY pair ORDER BY ydate)npg4_ld
,LEAD(npg6,1,NULL)OVER(PARTITION BY pair ORDER BY ydate)npg6_ld
,LEAD(npg8,1,NULL)OVER(PARTITION BY pair ORDER BY ydate)npg8_ld
FROM tr16
ORDER BY pair,ydate
/


-- Look at both npg4 and npg4_ld

SELECT
pair
,sgn8
,ROUND(sgn8 * AVG(npg4),4)sgn8_x_npg4
,ROUND(sgn8 * AVG(npg4_ld),4)sgn8_x_npg4_ld
,COUNT(pair)cnt
FROM
(
  SELECT
  pair
  ,npg4
  ,sgn8
  ,npg4_ld
  FROM tr162
  WHERE ydate_ld BETWEEN ydate + 50/60/24 AND ydate + 400/60/24
)
WHERE sgn8 * npg4 > 0.0010
GROUP BY pair,sgn8
ORDER BY pair,sgn8
/


-- Look at both npg6 and npg6_ld

SELECT
pair
,sgn8
,ROUND(sgn8 * AVG(npg6),4)sgn8_x_npg6
,ROUND(sgn8 * AVG(npg6_ld),4)sgn8_x_npg6_ld
,COUNT(pair)cnt
FROM
(
  SELECT
  pair
  ,npg6
  ,sgn8
  ,npg6_ld
  FROM tr162
  WHERE ydate_ld BETWEEN ydate + 70/60/24 AND ydate + 600/60/24
)
WHERE sgn8 * npg6 > 0.0011
GROUP BY pair,sgn8
ORDER BY pair,sgn8
/


-- Look at both npg8 and npg8_ld

SELECT
pair
,sgn8
,ROUND(sgn8 * AVG(npg8),4)sgn8_x_npg8
,ROUND(sgn8 * AVG(npg8_ld),4)sgn8_x_npg8_ld
,COUNT(pair)cnt
FROM
(
  SELECT
  pair
  ,npg8
  ,sgn8
  ,npg8_ld
  FROM tr162
  WHERE ydate_ld BETWEEN ydate + 90/60/24 AND ydate + 900/60/24
)
WHERE sgn8 * npg8 > 0.0011
GROUP BY pair,sgn8
ORDER BY pair,sgn8
/

EXIT
