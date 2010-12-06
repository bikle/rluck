--
-- t18.sql
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
-- Relative to current-row, get future closing prices.
-- 1 hr:
,LEAD(clse,6,NULL)OVER(PARTITION BY pair ORDER BY ydate) clse1
-- 2 hr:
,LEAD(clse,12,NULL)OVER(PARTITION BY pair ORDER BY ydate)clse2
-- 3 hr:
,LEAD(clse,18,NULL)OVER(PARTITION BY pair ORDER BY ydate)clse3
-- 4 hr:
,LEAD(clse,24,NULL)OVER(PARTITION BY pair ORDER BY ydate)clse4
-- 6 hr:
,LEAD(clse,36,NULL)OVER(PARTITION BY pair ORDER BY ydate)clse6
-- 8 hr:
,LEAD(clse,48,NULL)OVER(PARTITION BY pair ORDER BY ydate)clse8
-- 12 hr:
,LEAD(clse,72,NULL)OVER(PARTITION BY pair ORDER BY ydate)clse12
-- 16 hr:
,LEAD(clse,96,NULL)OVER(PARTITION BY pair ORDER BY ydate)clse16
-- 24 hr:
,LEAD(clse,144,NULL)OVER(PARTITION BY pair ORDER BY ydate)clse24
FROM dukas10min
-- Prevent divide by zero:
WHERE clse > 0
ORDER BY pair,ydate
/

-- I collect normalized gains.
-- I normalize the gains so I can compare JPY to AUD, CHF, CAD:
-- usd_jpy is near 85.
-- aud_usd, usd_cad, usd_chf are near 1.

CREATE OR REPLACE VIEW tr12 AS
SELECT
pair
,ydate
,clse
-- I collect normalized gains:
,(clse1-clse)/clse npg1
,(clse2-clse)/clse npg2
,(clse3-clse)/clse npg3
,(clse4-clse)/clse npg4
,(clse6-clse)/clse npg6
,(clse8-clse)/clse npg8
,(clse12-clse)/clse npg12
-- Jump ahead in time:
,(clse2-clse1)/clse npg21
,(clse4-clse2)/clse npg22
,(clse6-clse3)/clse npg23
,(clse8-clse4)/clse npg24
,(clse12-clse6)/clse npg26
,(clse16-clse8)/clse npg28
,(clse24-clse12)/clse npg212
FROM tr10
ORDER BY pair,ydate
/

-- Collect everything into a table which should help query performance.
-- Additionally, collect rolling-STDDEV() of npgX:

DROP TABLE tr14;
PURGE RECYCLEBIN;
CREATE TABLE tr14 COMPRESS AS
SELECT
pair
,ydate
,clse
,npg1
,npg2
,npg3
,npg4
,npg6
,npg8
,npg12
,npg21
,npg22
,npg23
,npg24
,npg26
,npg28
,npg212
,NTILE(5)OVER(PARTITION BY pair ORDER BY npg1 )nt1 
,NTILE(5)OVER(PARTITION BY pair ORDER BY npg2 )nt2 
,NTILE(5)OVER(PARTITION BY pair ORDER BY npg3 )nt3 
,NTILE(5)OVER(PARTITION BY pair ORDER BY npg4 )nt4 
,NTILE(5)OVER(PARTITION BY pair ORDER BY npg6 )nt6 
,NTILE(5)OVER(PARTITION BY pair ORDER BY npg8 )nt8 
,NTILE(5)OVER(PARTITION BY pair ORDER BY npg12)nt12
,STDDEV(npg1 )OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 200*1  PRECEDING AND CURRENT ROW)std1 
,STDDEV(npg2 )OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 200*2  PRECEDING AND CURRENT ROW)std2 
,STDDEV(npg3 )OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 200*3  PRECEDING AND CURRENT ROW)std3 
,STDDEV(npg4 )OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 200*4  PRECEDING AND CURRENT ROW)std4 
,STDDEV(npg6 )OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 200*6  PRECEDING AND CURRENT ROW)std6 
,STDDEV(npg8 )OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 200*8  PRECEDING AND CURRENT ROW)std8 
,STDDEV(npg12)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 200*12 PRECEDING AND CURRENT ROW)std12
FROM tr12
ORDER BY pair,ydate
/

ANALYZE TABLE tr14 ESTIMATE STATISTICS SAMPLE 9 PERCENT;

-- Look at CORR() between t1 and t2:

SELECT
nt1
,pair
,COUNT(pair)
,ROUND(CORR(npg1 ,npg21 ),2)crr1hr ,ROUND(AVG(npg1 ),4)avg_npg1 ,ROUND(AVG(npg21 ),4)avg_npg21 
FROM tr14
GROUP BY nt1,pair
ORDER BY nt1,pair
/

SELECT
nt2
,pair
,COUNT(pair)
,ROUND(CORR(npg2 ,npg22 ),2)crr2hr ,ROUND(AVG(npg2 ),4)avg_npg2 ,ROUND(AVG(npg22 ),4)avg_npg22 
FROM tr14
GROUP BY nt2,pair
ORDER BY nt2,pair
/

SELECT
nt3
,pair
,COUNT(pair)
,ROUND(CORR(npg3 ,npg23 ),2)crr3hr ,ROUND(AVG(npg3 ),4)avg_npg3 ,ROUND(AVG(npg23 ),4)avg_npg23 
FROM tr14
GROUP BY nt3,pair
ORDER BY nt3,pair
/

SELECT
nt4
,pair
,COUNT(pair)
,ROUND(CORR(npg4 ,npg24 ),2)crr4hr ,ROUND(AVG(npg4 ),4)avg_npg4 ,ROUND(AVG(npg24 ),4)avg_npg24 
FROM tr14
GROUP BY nt4,pair
ORDER BY nt4,pair
/

SELECT
nt6
,pair
,COUNT(pair)
,ROUND(CORR(npg6 ,npg26 ),2)crr6hr ,ROUND(AVG(npg6 ),4)avg_npg6 ,ROUND(AVG(npg26 ),4)avg_npg26 
FROM tr14
GROUP BY nt6,pair
ORDER BY nt6,pair
/


SELECT
nt8
,pair
,COUNT(pair)
,ROUND(CORR(npg8 ,npg28 ),2)crr8hr ,ROUND(AVG(npg8 ),4)avg_npg8 ,ROUND(AVG(npg28 ),4)avg_npg28 
FROM tr14
GROUP BY nt8,pair
ORDER BY nt8,pair
/


SELECT
nt12
,pair
,COUNT(pair)
,ROUND(CORR(npg12 ,npg212 ),2)crr12hr ,ROUND(AVG(npg12 ),4)avg_npg12 ,ROUND(AVG(npg212 ),4)avg_npg212 
FROM tr14
GROUP BY nt12,pair
ORDER BY nt12,pair
/


-- Look at CORR() between t1 and t2.
-- Use STDDEV() instead of NTILE():

SELECT
nt1
,pair
,COUNT(pair)
,ROUND(CORR(npg1 ,npg21 ),2)crr1hr ,ROUND(AVG(npg1 ),4)avg_npg1 ,ROUND(AVG(npg21 ),4)avg_npg21 
FROM tr14
WHERE ABS(npg1)> 4*std1 AND nt1 IN(1,5)
GROUP BY nt1,pair
ORDER BY nt1,pair
/

SELECT
nt2
,pair
,COUNT(pair)
,ROUND(CORR(npg2 ,npg22 ),2)crr2hr ,ROUND(AVG(npg2 ),4)avg_npg2 ,ROUND(AVG(npg22 ),4)avg_npg22 
FROM tr14
WHERE ABS(npg2)> 4*std2 AND nt2 IN(1,5)
GROUP BY nt2,pair
ORDER BY nt2,pair
/

SELECT
nt3
,pair
,COUNT(pair)
,ROUND(CORR(npg3 ,npg23 ),2)crr3hr ,ROUND(AVG(npg3 ),4)avg_npg3 ,ROUND(AVG(npg23 ),4)avg_npg23 
FROM tr14
WHERE ABS(npg3)> 4*std3 AND nt3 IN(1,5)
GROUP BY nt3,pair
ORDER BY nt3,pair
/

SELECT
nt4
,pair
,COUNT(pair)
,ROUND(CORR(npg4 ,npg24 ),2)crr4hr ,ROUND(AVG(npg4 ),4)avg_npg4 ,ROUND(AVG(npg24 ),4)avg_npg24 
FROM tr14
WHERE ABS(npg4)> 4*std4 AND nt4 IN(1,5)
GROUP BY nt4,pair
ORDER BY nt4,pair
/

SELECT
nt6
,pair
,COUNT(pair)
,ROUND(CORR(npg6 ,npg26 ),2)crr6hr ,ROUND(AVG(npg6 ),4)avg_npg6 ,ROUND(AVG(npg26 ),4)avg_npg26 
FROM tr14
WHERE ABS(npg6)> 4*std6 AND nt6 IN(1,5)
GROUP BY nt6,pair
ORDER BY nt6,pair
/

SELECT
nt8
,pair
,COUNT(pair)
,ROUND(CORR(npg8 ,npg28 ),2)crr8hr ,ROUND(AVG(npg8 ),4)avg_npg8 ,ROUND(AVG(npg28 ),4)avg_npg28 
FROM tr14
WHERE ABS(npg8)> 4*std8 AND nt8 IN(1,5)
GROUP BY nt8,pair
ORDER BY nt8,pair
/

SELECT
nt12
,pair
,COUNT(pair)
,ROUND(CORR(npg12 ,npg212 ),2)crr12hr ,ROUND(AVG(npg12 ),4)avg_npg12 ,ROUND(AVG(npg212 ),4)avg_npg212 
FROM tr14
WHERE ABS(npg12)> 3*std12 AND nt12 IN(1,5)
GROUP BY nt12,pair
ORDER BY nt12,pair
/

EXIT
