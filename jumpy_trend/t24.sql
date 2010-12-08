--
-- t24.sql
--

-- I use this script to look at Forex data which has a 10 minute duration between each datapoint.
-- This script was derived from t22.sql
-- The enhancement I added are 2 additional columns to some of the queries:
-- Year, and Quarter.
-- Also I added predicates which match those I have in my actual trading scripts.

SET LINES 66
DESC dukas10min
SET LINES 166

SELECT
TO_CHAR(ydate,'YYYY')yr
,TO_CHAR(ydate,'Q')qtr
,pair
,MIN(ydate)
,COUNT(*)
,MAX(ydate)
FROM dukas10min
GROUP BY TO_CHAR(ydate,'YYYY'),TO_CHAR(ydate,'Q'),pair
ORDER BY TO_CHAR(ydate,'YYYY'),TO_CHAR(ydate,'Q'),pair
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

DROP TABLE jt24;
PURGE RECYCLEBIN;
CREATE TABLE jt24 COMPRESS AS
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

ANALYZE TABLE jt24 ESTIMATE STATISTICS SAMPLE 9 PERCENT;

-- Display the standard deviation distribution for later reference:
SELECT
TO_CHAR(ydate,'YYYY')yr
,TO_CHAR(ydate,'Q')qtr
,pair
,ROUND(STDDEV(lg2 ),4)std2
,ROUND(STDDEV(lg4 ),4)std4
,ROUND(STDDEV(lg6 ),4)std6
,ROUND(STDDEV(lg8 ),4)std8
,ROUND(STDDEV(lg10),4)std10
,ROUND(STDDEV(lg12),4)std12
,ROUND(STDDEV(lg14),4)std14
,ROUND(STDDEV(lg16),4)std16
FROM tr12
GROUP BY pair,TO_CHAR(ydate,'YYYY'),TO_CHAR(ydate,'Q')
ORDER BY pair,TO_CHAR(ydate,'YYYY'),TO_CHAR(ydate,'Q')
/

COLUMN trend  FORMAT 99999
COLUMN countt FORMAT 99999

-- Look at CORR() between t1 and t2.

SELECT
TO_CHAR(ydate,'YYYY')yr
,TO_CHAR(ydate,'Q')qtr
,nt2-2 trend
,pair
,COUNT(pair)
,ROUND(CORR(lg2,npg2),2)crr2hr
,ROUND(AVG(lg2),4)      avg_lg2
,ROUND(SUM(npg4),4)     sum_npg4
,ROUND(AVG(npg2),4)     avg_npg2 
,ROUND(STDDEV(npg2),4)  stddv_npg2
FROM jt24
WHERE ABS(lg2)> 4*std2 AND nt2 IN(1,3)
GROUP BY TO_CHAR(ydate,'YYYY'),TO_CHAR(ydate,'Q'),nt2,pair
ORDER BY TO_CHAR(ydate,'YYYY'),TO_CHAR(ydate,'Q'),nt2,pair
/
-- Filter out pairs which historically, poorly fit this duration.
-- See:
-- https://github.com/bikle/rluck/blob/master/jumpy_trend/results2010_1206_t22.txt
SELECT
TO_CHAR(ydate,'YYYY')yr
,TO_CHAR(ydate,'Q')qtr
,nt2-2 trend
,pair
,COUNT(pair)
,ROUND(CORR(lg2,npg2),2)crr2hr
,ROUND(AVG(lg2),4)      avg_lg2
,ROUND(SUM(npg4),4)     sum_npg4
,ROUND(AVG(npg2),4)     avg_npg2 
,ROUND(STDDEV(npg2),4)  stddv_npg2
FROM jt24
WHERE ABS(lg2)> 4*std2 AND nt2 IN(1,3)
AND pair IN('aud_usd','usd_cad')
GROUP BY TO_CHAR(ydate,'YYYY'),TO_CHAR(ydate,'Q'),nt2,pair
ORDER BY TO_CHAR(ydate,'YYYY'),TO_CHAR(ydate,'Q'),nt2,pair
/

SELECT
TO_CHAR(ydate,'YYYY')yr
,TO_CHAR(ydate,'Q')qtr
,nt4-2 trend
,pair
,COUNT(pair)
,ROUND(CORR(lg4,npg4),2)crr4hr
,ROUND(AVG(lg4),4)      avg_lg4
,ROUND(SUM(npg4),4)     sum_npg4
,ROUND(AVG(npg4),4)     avg_npg4 
,ROUND(STDDEV(npg4),4)  stddv_npg4
FROM jt24
WHERE ABS(lg4)> 4*std4 AND nt4 IN(1,3)
GROUP BY TO_CHAR(ydate,'YYYY'),TO_CHAR(ydate,'Q'),nt4,pair
ORDER BY TO_CHAR(ydate,'YYYY'),TO_CHAR(ydate,'Q'),nt4,pair
/
-- Filter out pairs which historically, poorly fit this duration:
SELECT
TO_CHAR(ydate,'YYYY')yr
,TO_CHAR(ydate,'Q')qtr
,nt4-2 trend
,pair
,COUNT(pair)
,ROUND(CORR(lg4,npg4),2)crr4hr
,ROUND(AVG(lg4),4)      avg_lg4
,ROUND(SUM(npg4),4)     sum_npg4
,ROUND(AVG(npg4),4)     avg_npg4 
,ROUND(STDDEV(npg4),4)  stddv_npg4
FROM jt24
WHERE ABS(lg4)> 4*std4 AND nt4 IN(1,3)
AND pair IN('aud_usd','gbp_usd','usd_cad','usd_chf')
GROUP BY TO_CHAR(ydate,'YYYY'),TO_CHAR(ydate,'Q'),nt4,pair
ORDER BY TO_CHAR(ydate,'YYYY'),TO_CHAR(ydate,'Q'),nt4,pair
/

SELECT
TO_CHAR(ydate,'YYYY')yr
,TO_CHAR(ydate,'Q')qtr
,nt6-2 trend
,pair
,COUNT(pair)
,ROUND(CORR(lg6,npg6),2)crr6hr
,ROUND(AVG(lg6),4)      avg_lg6
,ROUND(SUM(npg6),4)     sum_npg6
,ROUND(AVG(npg6),4)     avg_npg6 
,ROUND(STDDEV(npg6),4)  stddv_npg6
FROM jt24
WHERE ABS(lg6)> 4*std6 AND nt6 IN(1,3)
GROUP BY TO_CHAR(ydate,'YYYY'),TO_CHAR(ydate,'Q'),nt6,pair
ORDER BY TO_CHAR(ydate,'YYYY'),TO_CHAR(ydate,'Q'),nt6,pair
/
-- Filter out pairs which historically, poorly fit this duration:
SELECT
TO_CHAR(ydate,'YYYY')yr
,TO_CHAR(ydate,'Q')qtr
,nt6-2 trend
,pair
,COUNT(pair)
,ROUND(CORR(lg6,npg6),2)crr6hr
,ROUND(AVG(lg6),4)      avg_lg6
,ROUND(SUM(npg6),4)     sum_npg6
,ROUND(AVG(npg6),4)     avg_npg6 
,ROUND(STDDEV(npg6),4)  stddv_npg6
FROM jt24
WHERE ABS(lg6)> 4*std6 AND nt6 IN(1,3)
AND pair IN('aud_usd','gbp_usd','usd_cad','usd_chf')
GROUP BY TO_CHAR(ydate,'YYYY'),TO_CHAR(ydate,'Q'),nt6,pair
ORDER BY TO_CHAR(ydate,'YYYY'),TO_CHAR(ydate,'Q'),nt6,pair
/

SELECT
TO_CHAR(ydate,'YYYY')yr
,TO_CHAR(ydate,'Q')qtr
,nt8-2 trend
,pair
,COUNT(pair)
,ROUND(CORR(lg8,npg8),2)crr8hr
,ROUND(AVG(lg8),4)      avg_lg8
,ROUND(SUM(npg8),4)     sum_npg8
,ROUND(AVG(npg8),4)     avg_npg8 
,ROUND(STDDEV(npg8),4)  stddv_npg8
FROM jt24
WHERE ABS(lg8)> 4*std8 AND nt8 IN(1,3)
GROUP BY TO_CHAR(ydate,'YYYY'),TO_CHAR(ydate,'Q'),nt8,pair
ORDER BY TO_CHAR(ydate,'YYYY'),TO_CHAR(ydate,'Q'),nt8,pair
/
-- Filter out pairs which historically, poorly fit this duration:
SELECT
TO_CHAR(ydate,'YYYY')yr
,TO_CHAR(ydate,'Q')qtr
,nt8-2 trend
,pair
,COUNT(pair)
,ROUND(CORR(lg8,npg8),2)crr8hr
,ROUND(AVG(lg8),4)      avg_lg8
,ROUND(SUM(npg8),4)     sum_npg8
,ROUND(AVG(npg8),4)     avg_npg8 
,ROUND(STDDEV(npg8),4)  stddv_npg8
FROM jt24
WHERE ABS(lg8)> 4*std8 AND nt8 IN(1,3)
AND pair IN('aud_usd','gbp_usd','usd_cad','usd_chf','usd_jpy')
GROUP BY TO_CHAR(ydate,'YYYY'),TO_CHAR(ydate,'Q'),nt8,pair
ORDER BY TO_CHAR(ydate,'YYYY'),TO_CHAR(ydate,'Q'),nt8,pair
/

SELECT
TO_CHAR(ydate,'YYYY')yr
,TO_CHAR(ydate,'Q')qtr
,nt10-2 trend
,pair
,COUNT(pair)
,ROUND(CORR(lg10,npg10),2)crr10hr
,ROUND(AVG(lg10),4)       avg_lg10
,ROUND(SUM(npg10),4)      sum_npg10
,ROUND(AVG(npg10),4)      avg_npg10 
,ROUND(STDDEV(npg10),4)   stddv_npg10
FROM jt24
WHERE ABS(lg10)> 4*std10 AND nt10 IN(1,3)
GROUP BY TO_CHAR(ydate,'YYYY'),TO_CHAR(ydate,'Q'),nt10,pair
ORDER BY TO_CHAR(ydate,'YYYY'),TO_CHAR(ydate,'Q'),nt10,pair
/
-- Filter out pairs which historically, poorly fit this duration:
SELECT
TO_CHAR(ydate,'YYYY')yr
,TO_CHAR(ydate,'Q')qtr
,nt10-2 trend
,pair
,COUNT(pair)
,ROUND(CORR(lg10,npg10),2)crr10hr
,ROUND(AVG(lg10),4)       avg_lg10
,ROUND(SUM(npg10),4)      sum_npg10
,ROUND(AVG(npg10),4)      avg_npg10 
,ROUND(STDDEV(npg10),4)   stddv_npg10
FROM jt24
WHERE ABS(lg10)> 4*std10 AND nt10 IN(1,3)
AND pair IN('aud_usd','gbp_usd','usd_cad','usd_chf','usd_jpy')
GROUP BY TO_CHAR(ydate,'YYYY'),TO_CHAR(ydate,'Q'),nt10,pair
ORDER BY TO_CHAR(ydate,'YYYY'),TO_CHAR(ydate,'Q'),nt10,pair
/

SELECT
TO_CHAR(ydate,'YYYY')yr
,TO_CHAR(ydate,'Q')qtr
,nt12-2 trend
,pair
,COUNT(pair)
,ROUND(CORR(lg12,npg12),2)crr12hr
,ROUND(AVG(lg12),4)       avg_lg12
,ROUND(SUM(npg12),4)      sum_npg12
,ROUND(AVG(npg12),4)      avg_npg12 
,ROUND(STDDEV(npg12),4)   stddv_npg12
FROM jt24
WHERE ABS(lg12)> 4*std12 AND nt12 IN(1,3)
GROUP BY TO_CHAR(ydate,'YYYY'),TO_CHAR(ydate,'Q'),nt12,pair
ORDER BY TO_CHAR(ydate,'YYYY'),TO_CHAR(ydate,'Q'),nt12,pair
/
-- Filter out pairs which historically, poorly fit this duration:
SELECT
TO_CHAR(ydate,'YYYY')yr
,TO_CHAR(ydate,'Q')qtr
,nt12-2 trend
,pair
,COUNT(pair)
,ROUND(CORR(lg12,npg12),2)crr12hr
,ROUND(AVG(lg12),4)       avg_lg12
,ROUND(SUM(npg12),4)      sum_npg12
,ROUND(AVG(npg12),4)      avg_npg12 
,ROUND(STDDEV(npg12),4)   stddv_npg12
FROM jt24
WHERE ABS(lg12)> 4*std12 AND nt12 IN(1,3)
AND pair IN('gbp_usd','eur_usd','usd_cad','usd_chf','usd_jpy')
GROUP BY TO_CHAR(ydate,'YYYY'),TO_CHAR(ydate,'Q'),nt12,pair
ORDER BY TO_CHAR(ydate,'YYYY'),TO_CHAR(ydate,'Q'),nt12,pair
/

SELECT
TO_CHAR(ydate,'YYYY')yr
,TO_CHAR(ydate,'Q')qtr
,nt14-2 trend
,pair
,COUNT(pair)
,ROUND(CORR(lg14,npg14),2)crr14hr
,ROUND(AVG(lg14),4)       avg_lg14
,ROUND(SUM(npg14),4)      sum_npg14
,ROUND(AVG(npg14),4)      avg_npg14 
,ROUND(STDDEV(npg14),4)   stddv_npg14
FROM jt24
WHERE ABS(lg14)> 4*std14 AND nt14 IN(1,3)
GROUP BY TO_CHAR(ydate,'YYYY'),TO_CHAR(ydate,'Q'),nt14,pair
ORDER BY TO_CHAR(ydate,'YYYY'),TO_CHAR(ydate,'Q'),nt14,pair
/
-- Filter out pairs which historically, poorly fit this duration:
SELECT
TO_CHAR(ydate,'YYYY')yr
,TO_CHAR(ydate,'Q')qtr
,nt14-2 trend
,pair
,COUNT(pair)
,ROUND(CORR(lg14,npg14),2)crr14hr
,ROUND(AVG(lg14),4)       avg_lg14
,ROUND(SUM(npg14),4)      sum_npg14
,ROUND(AVG(npg14),4)      avg_npg14 
,ROUND(STDDEV(npg14),4)   stddv_npg14
FROM jt24
WHERE ABS(lg14)> 4*std14 AND nt14 IN(1,3)
AND pair IN('gbp_usd','usd_cad','usd_chf','usd_jpy')
GROUP BY TO_CHAR(ydate,'YYYY'),TO_CHAR(ydate,'Q'),nt14,pair
ORDER BY TO_CHAR(ydate,'YYYY'),TO_CHAR(ydate,'Q'),nt14,pair
/

SELECT
TO_CHAR(ydate,'YYYY')yr
,TO_CHAR(ydate,'Q')qtr
,nt16-2 trend
,pair
,COUNT(pair)countt
,ROUND(CORR(lg16,npg16),2)crr16hr
,ROUND(AVG(lg16),4)       avg_lg16
,ROUND(SUM(npg16),4)      sum_npg16 
,ROUND(AVG(npg16),4)      avg_npg16 
,ROUND(STDDEV(npg16),4)   stddv_npg16
FROM jt24
WHERE ABS(lg16)> 4*std16 AND nt16 IN(1,3)
GROUP BY TO_CHAR(ydate,'YYYY'),TO_CHAR(ydate,'Q'),nt16,pair
ORDER BY TO_CHAR(ydate,'YYYY'),TO_CHAR(ydate,'Q'),nt16,pair
/
-- Filter out pairs which historically, poorly fit this duration:
SELECT
TO_CHAR(ydate,'YYYY')yr
,TO_CHAR(ydate,'Q')qtr
,nt16-2 trend
,pair
,COUNT(pair)countt
,ROUND(CORR(lg16,npg16),2)crr16hr
,ROUND(AVG(lg16),4)       avg_lg16
,ROUND(SUM(npg16),4)      sum_npg16 
,ROUND(AVG(npg16),4)      avg_npg16 
,ROUND(STDDEV(npg16),4)   stddv_npg16
FROM jt24
WHERE ABS(lg16)> 4*std16 AND nt16 IN(1,3)
AND pair IN('eur_usd','gbp_usd','usd_cad','usd_chf','usd_jpy')
GROUP BY TO_CHAR(ydate,'YYYY'),TO_CHAR(ydate,'Q'),nt16,pair
ORDER BY TO_CHAR(ydate,'YYYY'),TO_CHAR(ydate,'Q'),nt16,pair
/

EXIT
