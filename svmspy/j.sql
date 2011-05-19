
SELECT
tkr
,ydate
,clse
,rscore_diff2
,g1
,rnng_crr1
FROM us_stk_pst12
WHERE ydate > '2011-05-19 19:25:00'
-- WHERE ydate > sysdate - 2/24
AND rnng_crr1 > 0.1
AND ABS(rscore_diff2) > 0.3
ORDER BY
tkr
,ydate
,clse
/


exit
