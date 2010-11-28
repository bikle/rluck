
-- Is ma_slope correlated with npg?
SELECT 
pair
,COUNT(npg)
,CORR(ma4_slope,npg)
,CORR(ma6_slope,npg)
,CORR(ma9_slope,npg)
,CORR(ma12_slope,npg)
,CORR(ma18_slope,npg)
FROM svm4ms
GROUP BY pair
/

exit
