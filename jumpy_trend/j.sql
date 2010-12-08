
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

-- Look at CORR() between t1 and t2.

SELECT
TO_CHAR(ydate,'YYYY')yr
,TO_CHAR(ydate,'Q')qtr
,nt2-2 trend
,pair
,COUNT(pair)
,ROUND(CORR(lg2,npg2),2)crr2hr
,ROUND(AVG(lg2),4)      avg_lg2
,ROUND(AVG(npg2),4)     avg_npg2 
,ROUND(STDDEV(npg2),4)  stddv_npg2
FROM jt24
WHERE ABS(lg2)> 4*std2 AND nt2 IN(1,3)
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
,ROUND(AVG(npg4),4)     avg_npg4 
,ROUND(STDDEV(npg4),4)  stddv_npg4
FROM jt24
WHERE ABS(lg4)> 4*std4 AND nt4 IN(1,3)
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
,ROUND(AVG(npg6),4)     avg_npg6 
,ROUND(STDDEV(npg6),4)  stddv_npg6
FROM jt24
WHERE ABS(lg6)> 4*std6 AND nt6 IN(1,3)
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
,ROUND(AVG(npg8),4)     avg_npg8 
,ROUND(STDDEV(npg8),4)  stddv_npg8
FROM jt24
WHERE ABS(lg8)> 4*std8 AND nt8 IN(1,3)
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
,ROUND(AVG(npg10),4)      avg_npg10 
,ROUND(STDDEV(npg10),4)   stddv_npg10
FROM jt24
WHERE ABS(lg10)> 4*std10 AND nt10 IN(1,3)
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
,ROUND(AVG(npg12),4)      avg_npg12 
,ROUND(STDDEV(npg12),4)   stddv_npg12
FROM jt24
WHERE ABS(lg12)> 4*std12 AND nt12 IN(1,3)
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
,ROUND(AVG(npg14),4)      avg_npg14 
,ROUND(STDDEV(npg14),4)   stddv_npg14
FROM jt24
WHERE ABS(lg14)> 4*std14 AND nt14 IN(1,3)
GROUP BY TO_CHAR(ydate,'YYYY'),TO_CHAR(ydate,'Q'),nt14,pair
ORDER BY TO_CHAR(ydate,'YYYY'),TO_CHAR(ydate,'Q'),nt14,pair
/

SELECT
TO_CHAR(ydate,'YYYY')yr
,TO_CHAR(ydate,'Q')qtr
,nt16-2 trend
,pair
,COUNT(pair)
,ROUND(CORR(lg16,npg16),2)crr16hr
,ROUND(AVG(lg16),4)         avg_lg16
,ROUND(AVG(npg16),4)       avg_npg16 
,ROUND(STDDEV(npg16),4)    stddv_npg16
FROM jt24
WHERE ABS(lg16)> 4*std16 AND nt16 IN(1,3)
GROUP BY TO_CHAR(ydate,'YYYY'),TO_CHAR(ydate,'Q'),nt16,pair
ORDER BY TO_CHAR(ydate,'YYYY'),TO_CHAR(ydate,'Q'),nt16,pair
/

EXIT
