--
-- t22_12hr_3x_std12.sql
--

-- I use this to boost the row count from tr14 for npg12.

SELECT
nt12-2 trend
,pair
,COUNT(pair)
,ROUND(CORR(npg12,npg1812),2)crr12hr
,ROUND(AVG(npg12),4)         avg_npg12
,ROUND(AVG(npg1812),4)       avg_npg1812 
,ROUND(STDDEV(npg1812),4)    stddv_npg1812
FROM tr14
WHERE ABS(npg12)> 3*std12 AND nt12 IN(1,3)
GROUP BY nt12,pair
ORDER BY nt12,pair
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
-- Boost npg12 from 3.0 to 3.5:
WHERE ABS(npg12)> 3.5*std12 AND nt12 IN(1,3)
GROUP BY nt12,pair
ORDER BY nt12,pair
/

exit
