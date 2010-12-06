--
-- t22_14hr_3x_std14.sql
--

-- I use this to boost the row count from tr14 for npg14.

SELECT
nt14-2 trend
,pair
,COUNT(pair)
,ROUND(CORR(npg14,npg2114),2)crr14hr
,ROUND(AVG(npg14),4)         avg_npg14
,ROUND(AVG(npg2114),4)       avg_npg2114 
,ROUND(STDDEV(npg2114),4)    stddv_npg2114
FROM tr14
WHERE ABS(npg14)> 3*std14 AND nt14 IN(1,3)
GROUP BY nt14,pair
ORDER BY nt14,pair
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
WHERE ABS(npg14)> 3.5*std14 AND nt14 IN(1,3)
GROUP BY nt14,pair
ORDER BY nt14,pair
/


exit
