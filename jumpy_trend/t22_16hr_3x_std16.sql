--
-- t22_16hr_3x_std16.sql
--

-- I use this to boost the row count from tr14 for npg16.

SELECT
nt16-2 trend
,pair
,COUNT(pair)
,ROUND(CORR(npg16,npg2416),2)crr16hr
,ROUND(AVG(npg16),4)         avg_npg16
,ROUND(AVG(npg2416),4)       avg_npg2416 
,ROUND(STDDEV(npg2416),4)    stddv_npg2416
FROM tr14
WHERE ABS(npg16)> 3*std16 AND nt16 IN(1,3)
GROUP BY nt16,pair
ORDER BY nt16,pair
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
WHERE ABS(npg16)> 3.5*std16 AND nt16 IN(1,3)
GROUP BY nt16,pair
ORDER BY nt16,pair
/


exit
