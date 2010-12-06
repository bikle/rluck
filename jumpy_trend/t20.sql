--
-- t20.sql
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
-- I collect normalized gains.
-- I match t1 and         t2:
,(clse2-clse)/clse  npg2,(clse3-clse2)/clse    npg32
,(clse3-clse)/clse  npg3,(clse4-clse3)/clse    npg43
,(clse4-clse)/clse  npg4,(clse6-clse4)/clse    npg64
,(clse6-clse)/clse  npg6,(clse8-clse6)/clse    npg86
,(clse8-clse)/clse  npg8,(clse12-clse8)/clse   npg128
,(clse12-clse)/clse npg12,(clse16-clse12)/clse npg1612
,(clse16-clse)/clse npg16,(clse24-clse16)/clse npg2416
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
--t1,  t2:
,npg2, npg32
,npg3, npg43
,npg4, npg64
,npg6, npg86
,npg8, npg128
,npg12, npg1612
,npg16, npg2416
-- I use ntX to help me separate positive npgX from negative npgX:
,NTILE(3)OVER(PARTITION BY pair ORDER BY npg2 )nt2 
,NTILE(3)OVER(PARTITION BY pair ORDER BY npg3 )nt3 
,NTILE(3)OVER(PARTITION BY pair ORDER BY npg4 )nt4 
,NTILE(3)OVER(PARTITION BY pair ORDER BY npg6 )nt6 
,NTILE(3)OVER(PARTITION BY pair ORDER BY npg8 )nt8 
,NTILE(3)OVER(PARTITION BY pair ORDER BY npg12)nt12
,NTILE(3)OVER(PARTITION BY pair ORDER BY npg16)nt16
,STDDEV(npg2 )OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 200*2  PRECEDING AND CURRENT ROW)std2 
,STDDEV(npg3 )OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 200*3  PRECEDING AND CURRENT ROW)std3 
,STDDEV(npg4 )OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 200*4  PRECEDING AND CURRENT ROW)std4 
,STDDEV(npg6 )OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 200*6  PRECEDING AND CURRENT ROW)std6 
,STDDEV(npg8 )OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 200*8  PRECEDING AND CURRENT ROW)std8 
,STDDEV(npg12)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 200*12 PRECEDING AND CURRENT ROW)std12
,STDDEV(npg16)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 200*16 PRECEDING AND CURRENT ROW)std16
FROM tr12
ORDER BY pair,ydate
/

ANALYZE TABLE tr14 ESTIMATE STATISTICS SAMPLE 9 PERCENT;

-- Look at CORR() between t1 and t2.

SELECT
nt2
,pair
,COUNT(pair)
,ROUND(CORR(npg2,npg32),2)crr2hr,ROUND(AVG(npg2),4)avg_npg2,ROUND(AVG(npg32),4)avg_npg32
FROM tr14
WHERE ABS(npg2)> 4*std2 AND nt2 IN(1,3)
GROUP BY nt2,pair
ORDER BY nt2,pair
/

SELECT
nt3
,pair
,COUNT(pair)
,ROUND(CORR(npg3,npg43),2)crr3hr,ROUND(AVG(npg3),4)avg_npg3,ROUND(AVG(npg43),4)avg_npg43 
FROM tr14
WHERE ABS(npg3)> 4*std3 AND nt3 IN(1,3)
GROUP BY nt3,pair
ORDER BY nt3,pair
/

SELECT
nt4
,pair
,COUNT(pair)
,ROUND(CORR(npg4,npg64),2)crr4hr,ROUND(AVG(npg4),4)avg_npg4,ROUND(AVG(npg64),4)avg_npg64
FROM tr14
WHERE ABS(npg4)> 4*std4 AND nt4 IN(1,3)
GROUP BY nt4,pair
ORDER BY nt4,pair
/

SELECT
nt6
,pair
,COUNT(pair)
,ROUND(CORR(npg6,npg86),2)crr6hr,ROUND(AVG(npg6),4)avg_npg6,ROUND(AVG(npg86),4)avg_npg86
FROM tr14
WHERE ABS(npg6)> 4*std6 AND nt6 IN(1,3)
GROUP BY nt6,pair
ORDER BY nt6,pair
/

SELECT
nt8
,pair
,COUNT(pair)
,ROUND(CORR(npg8,npg128),2)crr8hr,ROUND(AVG(npg8),4)avg_npg8,ROUND(AVG(npg128),4)avg_npg128 
FROM tr14
WHERE ABS(npg8)> 4*std8 AND nt8 IN(1,3)
GROUP BY nt8,pair
ORDER BY nt8,pair
/

SELECT
nt12
,pair
,COUNT(pair)
,ROUND(CORR(npg12,npg1612),2)crr12hr,ROUND(AVG(npg12),4)avg_npg12,ROUND(AVG(npg1612),4)avg_npg1612 
FROM tr14
WHERE ABS(npg12)> 3.5*std12 AND nt12 IN(1,3)
GROUP BY nt12,pair
ORDER BY nt12,pair
/

SELECT
nt16
,pair
,COUNT(pair)
,ROUND(CORR(npg16,npg2416),2)crr16hr,ROUND(AVG(npg16),4)avg_npg16,ROUND(AVG(npg2416),4)avg_npg2416
FROM tr14
WHERE ABS(npg12)> 3.5*std12 AND nt12 IN(1,3)
GROUP BY nt16,pair
ORDER BY nt16,pair
/

EXIT
