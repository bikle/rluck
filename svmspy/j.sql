
SELECT
tkr
,ydate
,clse
,rscore_diff2
,g1
,rnng_crr1
FROM us_stk_pst12
WHERE ydate > sysdate - 3/24
-- WHERE ydate > '2011-04-20 18:33'
AND rnng_crr1 > 0.05
AND ABS(rscore_diff2) > 0.1
ORDER BY
tkr
,ydate
,clse
/


exit
