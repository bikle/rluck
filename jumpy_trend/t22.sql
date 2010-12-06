--
-- t22.sql
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
-- 2 hr:
,LEAD(clse,12,NULL)OVER(PARTITION BY pair ORDER BY ydate)clse2
-- 3 hr:
,LEAD(clse,3 *6,NULL)OVER(PARTITION BY pair ORDER BY ydate)clse3
,LEAD(clse,4 *6,NULL)OVER(PARTITION BY pair ORDER BY ydate)clse4
,LEAD(clse,6 *6,NULL)OVER(PARTITION BY pair ORDER BY ydate)clse6
,LEAD(clse,8 *6,NULL)OVER(PARTITION BY pair ORDER BY ydate)clse8
,LEAD(clse,9 *6,NULL)OVER(PARTITION BY pair ORDER BY ydate)clse9
,LEAD(clse,10*6,NULL)OVER(PARTITION BY pair ORDER BY ydate)clse10
,LEAD(clse,12*6,NULL)OVER(PARTITION BY pair ORDER BY ydate)clse12
,LEAD(clse,14*6,NULL)OVER(PARTITION BY pair ORDER BY ydate)clse14
,LEAD(clse,15*6,NULL)OVER(PARTITION BY pair ORDER BY ydate)clse15
,LEAD(clse,16*6,NULL)OVER(PARTITION BY pair ORDER BY ydate)clse16
,LEAD(clse,18*6,NULL)OVER(PARTITION BY pair ORDER BY ydate)clse18
,LEAD(clse,21*6,NULL)OVER(PARTITION BY pair ORDER BY ydate)clse21
,LEAD(clse,24*6,NULL)OVER(PARTITION BY pair ORDER BY ydate)clse24
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
,(clse4-clse)/clse  npg4,(clse6-clse4)/clse    npg64
,(clse6-clse)/clse  npg6,(clse9-clse6)/clse    npg96
,(clse8-clse)/clse  npg8,(clse12-clse8)/clse   npg128
,(clse10-clse)/clse npg10,(clse15-clse10)/clse npg1510
,(clse12-clse)/clse npg12,(clse18-clse12)/clse npg1812
,(clse14-clse)/clse npg14,(clse21-clse14)/clse npg2114
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
,npg4, npg64
,npg6, npg96
,npg8, npg128
,npg10, npg1510
,npg12, npg1812
,npg14, npg2114
,npg16, npg2416
-- I use ntX to help me separate positive npgX from negative npgX:
,NTILE(3)OVER(PARTITION BY pair ORDER BY npg2 )nt2 
,NTILE(3)OVER(PARTITION BY pair ORDER BY npg4 )nt4 
,NTILE(3)OVER(PARTITION BY pair ORDER BY npg6 )nt6 
,NTILE(3)OVER(PARTITION BY pair ORDER BY npg8 )nt8 
,NTILE(3)OVER(PARTITION BY pair ORDER BY npg10)nt10
,NTILE(3)OVER(PARTITION BY pair ORDER BY npg12)nt12
,NTILE(3)OVER(PARTITION BY pair ORDER BY npg14)nt14
,NTILE(3)OVER(PARTITION BY pair ORDER BY npg16)nt16
,STDDEV(npg2 )OVER(PARTITION BY pair)std2 
,STDDEV(npg4 )OVER(PARTITION BY pair)std4 
,STDDEV(npg6 )OVER(PARTITION BY pair)std6 
,STDDEV(npg8 )OVER(PARTITION BY pair)std8 
,STDDEV(npg10)OVER(PARTITION BY pair)std10
,STDDEV(npg12)OVER(PARTITION BY pair)std12
,STDDEV(npg14)OVER(PARTITION BY pair)std14
,STDDEV(npg16)OVER(PARTITION BY pair)std16
FROM tr12
ORDER BY pair,ydate
/

ANALYZE TABLE tr14 ESTIMATE STATISTICS SAMPLE 9 PERCENT;

-- Display the standard deviation distribution for later reference:
SELECT
pair
,ROUND(STDDEV(npg2 ),4)std2
,ROUND(STDDEV(npg4 ),4)std4
,ROUND(STDDEV(npg6 ),4)std6
,ROUND(STDDEV(npg8 ),4)std8
,ROUND(STDDEV(npg10),4)std10
,ROUND(STDDEV(npg12),4)std12
,ROUND(STDDEV(npg14),4)std14
,ROUND(STDDEV(npg16),4)std16
FROM tr12
GROUP BY pair
ORDER BY pair
/

-- Look at CORR() between t1 and t2.

SELECT
nt2-2 trend
,pair
,COUNT(pair)
,ROUND(CORR(npg2,npg32),2)crr2hr
,ROUND(AVG(npg2),4)       avg_npg2
,ROUND(AVG(npg32),4)      avg_npg32
,ROUND(STDDEV(npg32),4)   stddv_npg32
FROM tr14
WHERE ABS(npg2)> 4*std2 AND nt2 IN(1,3)
GROUP BY nt2,pair
ORDER BY nt2,pair
/

SELECT
nt4-2 trend
,pair
,COUNT(pair)
,ROUND(CORR(npg4,npg64),2)crr4hr
,ROUND(AVG(npg4),4)       avg_npg4
,ROUND(AVG(npg64),4)      avg_npg64
,ROUND(STDDEV(npg64),4)   stddv_npg64
FROM tr14
WHERE ABS(npg4)> 4*std4 AND nt4 IN(1,3)
GROUP BY nt4,pair
ORDER BY nt4,pair
/

SELECT
nt6-2 trend
,pair
,COUNT(pair)
,ROUND(CORR(npg6,npg96),2)crr6hr
,ROUND(AVG(npg6),4)       avg_npg6
,ROUND(AVG(npg96),4)      avg_npg96
,ROUND(STDDEV(npg96),4)   stddv_npg96
FROM tr14
WHERE ABS(npg6)> 4*std6 AND nt6 IN(1,3)
GROUP BY nt6,pair
ORDER BY nt6,pair
/

SELECT
nt8-2 trend
,pair
,COUNT(pair)
,ROUND(CORR(npg8,npg128),2)crr8hr
,ROUND(AVG(npg8),4)        avg_npg8
,ROUND(AVG(npg128),4)      avg_npg128 
,ROUND(STDDEV(npg128),4)   stddv_npg128
FROM tr14
WHERE ABS(npg8)> 4*std8 AND nt8 IN(1,3)
GROUP BY nt8,pair
ORDER BY nt8,pair
/

SELECT
nt10-2 trend
,pair
,COUNT(pair)
,ROUND(CORR(npg10,npg1510),2)crr10hr
,ROUND(AVG(npg10),4)         avg_npg10
,ROUND(AVG(npg1510),4)       avg_npg1510 
,ROUND(STDDEV(npg1510),4)    stddv_npg1510
FROM tr14
WHERE ABS(npg10)> 4*std10 AND nt10 IN(1,3)
GROUP BY nt10,pair
ORDER BY nt10,pair
/


SELECT
nt12-2 trend
,pair
,COUNT(pair)
,ROUND(CORR(npg12,npg1812),2)crr12hr
,ROUND(AVG(npg12),4)         avg_npg12
,ROUND(AVG(npg1812),4)       avg_npg1812 
,ROUND(STDDEV(npg1812),4)    stddv_npg1812
FROM tr14
WHERE ABS(npg12)> 4*std12 AND nt12 IN(1,3)
GROUP BY nt12,pair
ORDER BY nt12,pair
/

SELECT
nt14-2 trend
,pair
,COUNT(pair)
,ROUND(CORR(npg14,npg2114),2)crr14hr
,ROUND(AVG(npg14),4)         avg_npg14
,ROUND(AVG(npg2114),4)       avg_npg2114 
,ROUND(STDDEV(npg2114),4)    stddv_npg2114
FROM tr14
WHERE ABS(npg14)> 4*std14 AND nt14 IN(1,3)
GROUP BY nt14,pair
ORDER BY nt14,pair
/

SELECT
nt16-2 trend
,pair
,COUNT(pair)
,ROUND(CORR(npg16,npg2416),2)crr16hr
,ROUND(AVG(npg16),4)         avg_npg16
,ROUND(AVG(npg2416),4)       avg_npg2416 
,ROUND(STDDEV(npg2416),4)    stddv_npg2416
FROM tr14
WHERE ABS(npg16)> 4*std16 AND nt16 IN(1,3)
GROUP BY nt16,pair
ORDER BY nt16,pair
/

EXIT
