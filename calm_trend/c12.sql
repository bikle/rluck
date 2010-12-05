--
-- c12.sql
--

-- I use this script to look at Forex data which has a 10 minute duration between each datapoint.
-- This script is similar to c10.sql but looks at longer intervals:
-- 4 hr = 240 min = 24 rows
-- 8 hr = 480 min = 48 rows
-- 12 hr = 720 min = 72 rows
-- 16 hr = 920 min = 92 rows
-- 24 hr = 24 x 60 min = 1440 min = 144 rows


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
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 27 PRECEDING AND 3 PRECEDING)ma1_24
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 52 PRECEDING AND 4 PRECEDING)ma1_48
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 98 PRECEDING AND 6 PRECEDING)ma1_92
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 152 PRECEDING AND 8 PRECEDING)ma1_144
-- Use analytic function to get moving average2:
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 24 PRECEDING AND CURRENT ROW)ma2_24
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 48 PRECEDING AND CURRENT ROW)ma2_48
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 92 PRECEDING AND CURRENT ROW)ma2_92
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 144 PRECEDING AND CURRENT ROW)ma2_144
-- Relative to current-row, get future closing prices.
-- 4hr:
,LEAD(clse,24,NULL)OVER(PARTITION BY pair ORDER BY ydate) clse24
-- 8hr:
,LEAD(clse,48,NULL)OVER(PARTITION BY pair ORDER BY ydate) clse48
-- 12hr:
,LEAD(clse,72,NULL)OVER(PARTITION BY pair ORDER BY ydate) clse72
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
,(ma2_24 - ma1_24)/ma1_24 ma24_slope
,(ma2_48 - ma1_48)/ma1_48 ma48_slope
,(ma2_92 - ma1_92)/ma1_92 ma92_slope
,(ma2_144 - ma1_144)/ma1_144 ma144_slope
-- I collect normalized gains too:
,(clse24-clse)/clse npg24
,(clse48-clse)/clse npg48
,(clse72-clse)/clse npg72
FROM tr10
-- prevent divide by 0:
WHERE(ma1_24*ma1_48*ma1_92*ma1_144)!=0
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
,ma24_slope
,ma48_slope
,ma92_slope
,ma144_slope
,npg24
,npg48
,npg72
-- Calculate running stddev over 10-day span:
,STDDEV(ma24_slope)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 6*24*10 PRECEDING AND CURRENT ROW)ma_stddev24
,STDDEV(ma48_slope)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 6*24*10 PRECEDING AND CURRENT ROW)ma_stddev48
,STDDEV(ma92_slope)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 6*24*10 PRECEDING AND CURRENT ROW)ma_stddev92
,STDDEV(ma144_slope)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 6*24*10 PRECEDING AND CURRENT ROW)ma_stddev144
-- Sign of slope is a useful attribute:
,SIGN(ma24_slope)sgn24
,SIGN(ma48_slope)sgn48
,SIGN(ma92_slope)sgn92
,SIGN(ma144_slope)sgn144
FROM tr12
ORDER BY pair,ydate
/

-- Now get rows with mellow slopes for sgn48:

CREATE OR REPLACE VIEW tr16 AS
SELECT
pair
,ydate
,npg24
,npg48
,npg72
,sgn48
FROM tr14
-- I want mellow slopes:
WHERE ABS(ma48_slope)BETWEEN 0.5*ma_stddev48 AND 1.2*ma_stddev48
ORDER BY pair,ydate
/

-- Now get future rows for sgn48:

CREATE OR REPLACE VIEW tr162 AS
SELECT
sgn48
,pair
,ydate
,npg24
,npg48
,npg72
,LEAD(ydate,1,NULL)OVER(PARTITION BY pair ORDER BY ydate)ydate_ld
,LEAD(npg24,25,NULL)OVER(PARTITION BY pair ORDER BY ydate)npg24_ld
,LEAD(npg48,49,NULL)OVER(PARTITION BY pair ORDER BY ydate)npg48_ld
,LEAD(npg72,73,NULL)OVER(PARTITION BY pair ORDER BY ydate)npg72_ld

,LEAD(sgn48,25,NULL)OVER(PARTITION BY pair ORDER BY ydate)sgn4824_ld
,LEAD(sgn48,49,NULL)OVER(PARTITION BY pair ORDER BY ydate)sgn4848_ld
,LEAD(sgn48,73,NULL)OVER(PARTITION BY pair ORDER BY ydate)sgn4872_ld

FROM tr16
ORDER BY pair,ydate
/

-- Look at both npgX and npgX_ld

SELECT
sgn48
,pair
,ROUND(sgn48 * AVG(npg24),4)sgn48_x_npg24
,ROUND(sgn48 * AVG(npg24_ld),4)sgn48_x_npg24_ld
,COUNT(pair)cnt
FROM
(
  SELECT
  pair
  ,npg24
  ,sgn48
  ,npg24_ld
  FROM tr162
  -- I want future npg24 between 4 hr ahead and 8 hr ahead:
  WHERE ydate_ld BETWEEN ydate + 4.2/24 AND ydate + 8.2/24
)
WHERE sgn48 * npg24 > 0.0010
GROUP BY pair,sgn48
ORDER BY pair,sgn48
/

exit

-- Look at both npg48 and npg48_ld

SELECT
pair
,sgn48
,ROUND(sgn48 * AVG(npg48),4)sgn48_x_npg48
,ROUND(sgn48 * AVG(npg48_ld),4)sgn48_x_npg48_ld
,COUNT(pair)cnt
FROM
(
  SELECT
  pair
  ,npg48
  ,sgn48
  ,npg48_ld
  FROM tr162
  WHERE ydate_ld BETWEEN ydate + 70/60/24 AND ydate + 600/60/24
)
WHERE sgn48 * npg48 > 0.0011
GROUP BY pair,sgn48
ORDER BY pair,sgn48
/


-- Look at both npg72 and npg72_ld

SELECT
pair
,sgn48
,ROUND(sgn48 * AVG(npg72),4)sgn48_x_npg72
,ROUND(sgn48 * AVG(npg72_ld),4)sgn48_x_npg72_ld
,COUNT(pair)cnt
FROM
(
  SELECT
  pair
  ,npg72
  ,sgn48
  ,npg72_ld
  FROM tr162
  WHERE ydate_ld BETWEEN ydate + 90/60/24 AND ydate + 900/60/24
)
WHERE sgn48 * npg72 > 0.0011
GROUP BY pair,sgn48
ORDER BY pair,sgn48
/

exit



CREATE OR REPLACE VIEW tr16 AS
SELECT
pair
,ydate
,npg24
,npg48
,npg72
,sgn144
FROM tr14
-- I want mellow slopes:
WHERE ABS(ma144_slope)BETWEEN 0.5*ma_stddev144 AND 1.2*ma_stddev144
ORDER BY pair,ydate
/

-- Now get future rows:

CREATE OR REPLACE VIEW tr162 AS
SELECT
pair
,ydate
,npg24
,npg48
,npg72
,sgn144
,LEAD(ydate,1,NULL)OVER(PARTITION BY pair ORDER BY ydate)ydate_ld
,LEAD(npg24,1,NULL)OVER(PARTITION BY pair ORDER BY ydate)npg24_ld
,LEAD(npg48,1,NULL)OVER(PARTITION BY pair ORDER BY ydate)npg48_ld
,LEAD(npg72,1,NULL)OVER(PARTITION BY pair ORDER BY ydate)npg72_ld
FROM tr16
ORDER BY pair,ydate
/

-- Look at both npg24 and npg24_ld

SELECT
pair
,sgn144
,ROUND(sgn144 * AVG(npg24),4)sgn144_x_npg24
,ROUND(sgn144 * AVG(npg24_ld),4)sgn144_x_npg24_ld
,COUNT(pair)cnt
FROM
(
  SELECT
  pair
  ,npg24
  ,sgn144
  ,npg24_ld
  FROM tr162
  WHERE ydate_ld BETWEEN ydate + 50/60/24 AND ydate + 400/60/24
)
WHERE sgn144 * npg24 > 0.0012
GROUP BY pair,sgn144
ORDER BY pair,sgn144
/

-- Look at both npg48 and npg48_ld

SELECT
pair
,sgn144
,ROUND(sgn144 * AVG(npg48),4)sgn144_x_npg48
,ROUND(sgn144 * AVG(npg48_ld),4)sgn144_x_npg48_ld
,COUNT(pair)cnt
FROM
(
  SELECT
  pair
  ,npg48
  ,sgn144
  ,npg48_ld
  FROM tr162
  WHERE ydate_ld BETWEEN ydate + 70/60/24 AND ydate + 600/60/24
)
WHERE sgn144 * npg48 > 0.0016
GROUP BY pair,sgn144
ORDER BY pair,sgn144
/


-- Look at both npg72 and npg72_ld

SELECT
pair
,sgn144
,ROUND(sgn144 * AVG(npg72),4)sgn144_x_npg72
,ROUND(sgn144 * AVG(npg72_ld),4)sgn144_x_npg72_ld
,COUNT(pair)cnt
FROM
(
  SELECT
  pair
  ,npg72
  ,sgn144
  ,npg72_ld
  FROM tr162
  WHERE ydate_ld BETWEEN ydate + 90/60/24 AND ydate + 800/60/24
)
WHERE sgn144 * npg72 > 0.0021
GROUP BY pair,sgn144
ORDER BY pair,sgn144
/


-- Now get rows with mellow slopes for ma16:

CREATE OR REPLACE VIEW tr16 AS
SELECT
pair
,ydate
,npg24
,npg48
,npg72
,sgn92
FROM tr14
-- I want mellow slopes:
WHERE ABS(ma92_slope)BETWEEN 0.5*ma_stddev92 AND 1.2*ma_stddev92
ORDER BY pair,ydate
/

-- Now get future rows:

CREATE OR REPLACE VIEW tr162 AS
SELECT
pair
,ydate
,npg24
,npg48
,npg72
,sgn92
,LEAD(ydate,1,NULL)OVER(PARTITION BY pair ORDER BY ydate)ydate_ld
,LEAD(npg24,1,NULL)OVER(PARTITION BY pair ORDER BY ydate)npg24_ld
,LEAD(npg48,1,NULL)OVER(PARTITION BY pair ORDER BY ydate)npg48_ld
,LEAD(npg72,1,NULL)OVER(PARTITION BY pair ORDER BY ydate)npg72_ld
FROM tr16
ORDER BY pair,ydate
/


-- Look at both npg24 and npg24_ld

SELECT
pair
,sgn92
,ROUND(sgn92 * AVG(npg24),4)sgn92_x_npg24
,ROUND(sgn92 * AVG(npg24_ld),4)sgn92_x_npg24_ld
,COUNT(pair)cnt
FROM
(
  SELECT
  pair
  ,npg24
  ,sgn92
  ,npg24_ld
  FROM tr162
  WHERE ydate_ld BETWEEN ydate + 50/60/24 AND ydate + 400/60/24
)
WHERE sgn92 * npg24 > 0.0010
GROUP BY pair,sgn92
ORDER BY pair,sgn92
/


-- Look at both npg48 and npg48_ld

SELECT
pair
,sgn92
,ROUND(sgn92 * AVG(npg48),4)sgn92_x_npg48
,ROUND(sgn92 * AVG(npg48_ld),4)sgn92_x_npg48_ld
,COUNT(pair)cnt
FROM
(
  SELECT
  pair
  ,npg48
  ,sgn92
  ,npg48_ld
  FROM tr162
  WHERE ydate_ld BETWEEN ydate + 70/60/24 AND ydate + 600/60/24
)
WHERE sgn92 * npg48 > 0.0011
GROUP BY pair,sgn92
ORDER BY pair,sgn92
/


-- Look at both npg72 and npg72_ld

SELECT
pair
,sgn92
,ROUND(sgn92 * AVG(npg72),4)sgn92_x_npg72
,ROUND(sgn92 * AVG(npg72_ld),4)sgn92_x_npg72_ld
,COUNT(pair)cnt
FROM
(
  SELECT
  pair
  ,npg72
  ,sgn92
  ,npg72_ld
  FROM tr162
  WHERE ydate_ld BETWEEN ydate + 90/60/24 AND ydate + 900/60/24
)
WHERE sgn92 * npg72 > 0.0011
GROUP BY pair,sgn92
ORDER BY pair,sgn92
/



EXIT
