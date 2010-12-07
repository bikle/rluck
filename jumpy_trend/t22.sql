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
-- Relative to current-row, get past closing prices.
-- They are separated by 2 hours apart:
-- 2 hr:
,LAG(clse,2*6,NULL)OVER(PARTITION BY pair ORDER BY ydate)lgclse2
-- 4 hr:
,LAG(clse,4*6,NULL)OVER(PARTITION BY pair ORDER BY ydate)lgclse4
,LAG(clse,6*6,NULL)OVER(PARTITION BY pair ORDER BY ydate)lgclse6
,LAG(clse,8*6,NULL)OVER(PARTITION BY pair ORDER BY ydate)lgclse8
,LAG(clse,10*6,NULL)OVER(PARTITION BY pair ORDER BY ydate)lgclse10
,LAG(clse,12*6,NULL)OVER(PARTITION BY pair ORDER BY ydate)lgclse12
,LAG(clse,14*6,NULL)OVER(PARTITION BY pair ORDER BY ydate)lgclse14
,LAG(clse,16*6,NULL)OVER(PARTITION BY pair ORDER BY ydate)lgclse16
-- Relative to current-row, get future closing prices.
-- They are separated by 1 hour apart:
-- 1hr:
,LEAD(clse,1*6,NULL)OVER(PARTITION BY pair ORDER BY ydate)clse1
-- 2 hr:
,LEAD(clse,2*6,NULL)OVER(PARTITION BY pair ORDER BY ydate)clse2
,LEAD(clse,3*6,NULL)OVER(PARTITION BY pair ORDER BY ydate)clse3
,LEAD(clse,4*6,NULL)OVER(PARTITION BY pair ORDER BY ydate)clse4
,LEAD(clse,5*6,NULL)OVER(PARTITION BY pair ORDER BY ydate)clse5
,LEAD(clse,6*6,NULL)OVER(PARTITION BY pair ORDER BY ydate)clse6
,LEAD(clse,7*6,NULL)OVER(PARTITION BY pair ORDER BY ydate)clse7
,LEAD(clse,8*6,NULL)OVER(PARTITION BY pair ORDER BY ydate)clse8
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
,(clse-lgclse2)/clse  lg2,(clse1-clse)/clse  npg2    
,(clse-lgclse4)/clse  lg4,(clse2-clse)/clse  npg4   
,(clse-lgclse6)/clse  lg6,(clse3-clse)/clse  npg6   
,(clse-lgclse8)/clse  lg8,(clse4-clse)/clse  npg8   
,(clse-lgclse10)/clse lg10,(clse5-clse)/clse npg10
,(clse-lgclse12)/clse lg12,(clse6-clse)/clse npg12
,(clse-lgclse14)/clse lg14,(clse7-clse)/clse npg14
,(clse-lgclse16)/clse lg16,(clse8-clse)/clse npg16
FROM tr10
ORDER BY pair,ydate
/

-- Collect everything into a table which should help query performance.
-- Additionally, collect STDDEV() of lgX:

DROP TABLE tr14;
PURGE RECYCLEBIN;
CREATE TABLE tr14 COMPRESS AS
SELECT
pair
,ydate
,clse
--b4,  after:
,lg2,  npg2    
,lg4,  npg4   
,lg6,  npg6   
,lg8,  npg8   
,lg10, npg10
,lg12, npg12
,lg14, npg14
,lg16, npg16
-- I use ntX to help me separate positive lgX from negative lgX:
,NTILE(3)OVER(PARTITION BY pair ORDER BY lg2 )nt2 
,NTILE(3)OVER(PARTITION BY pair ORDER BY lg4 )nt4 
,NTILE(3)OVER(PARTITION BY pair ORDER BY lg6 )nt6 
,NTILE(3)OVER(PARTITION BY pair ORDER BY lg8 )nt8 
,NTILE(3)OVER(PARTITION BY pair ORDER BY lg10)nt10
,NTILE(3)OVER(PARTITION BY pair ORDER BY lg12)nt12
,NTILE(3)OVER(PARTITION BY pair ORDER BY lg14)nt14
,NTILE(3)OVER(PARTITION BY pair ORDER BY lg16)nt16
,STDDEV(lg2 )OVER(PARTITION BY pair)std2 
,STDDEV(lg4 )OVER(PARTITION BY pair)std4 
,STDDEV(lg6 )OVER(PARTITION BY pair)std6 
,STDDEV(lg8 )OVER(PARTITION BY pair)std8 
,STDDEV(lg10)OVER(PARTITION BY pair)std10
,STDDEV(lg12)OVER(PARTITION BY pair)std12
,STDDEV(lg14)OVER(PARTITION BY pair)std14
,STDDEV(lg16)OVER(PARTITION BY pair)std16
FROM tr12
ORDER BY pair,ydate
/

ANALYZE TABLE tr14 ESTIMATE STATISTICS SAMPLE 9 PERCENT;

-- Display the standard deviation distribution for later reference:
SELECT
pair
,ROUND(STDDEV(lg2 ),4)std2
,ROUND(STDDEV(lg4 ),4)std4
,ROUND(STDDEV(lg6 ),4)std6
,ROUND(STDDEV(lg8 ),4)std8
,ROUND(STDDEV(lg10),4)std10
,ROUND(STDDEV(lg12),4)std12
,ROUND(STDDEV(lg14),4)std14
,ROUND(STDDEV(lg16),4)std16
FROM tr12
GROUP BY pair
ORDER BY pair
/

-- Look at CORR() between t1 and t2.

SELECT
nt2-2 trend
,pair
,COUNT(pair)
,ROUND(CORR(lg2,npg2),2)crr2hr
,ROUND(AVG(lg2),4)       avg_lg2
,ROUND(AVG(npg2),4)      avg_npg2
,ROUND(STDDEV(npg2),4)   stddv_npg2
FROM tr14
WHERE ABS(lg2)> 4*std2 AND nt2 IN(1,3)
GROUP BY nt2,pair
ORDER BY nt2,pair
/


SELECT
nt4-2 trend
,pair
,COUNT(pair)
,ROUND(CORR(lg4,npg4),2)crr4hr
,ROUND(AVG(lg4),4)       avg_lg4
,ROUND(AVG(npg4),4)      avg_npg4
,ROUND(STDDEV(npg4),4)   stddv_npg4
FROM tr14
WHERE ABS(lg4)> 4*std4 AND nt4 IN(1,3)
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

exit

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
