
SELECT
pair
,ydate
,CASE WHEN rscore_diff2<0 THEN'sell'ELSE'buy'END bors
,ROUND(clse,4)clse
,rscore_diff2
,ROUND(g2,4)g2
,ROUND(rnng_crr1,2)      rnng_crr1
,(sysdate - ydate)*24*60 minutes_age
--,ydate + 6/24 cls_date
,TO_CHAR(ydate + 6/24,'YYYYMMDD_HH24:MI:SS')||'_GMT' cls_str
FROM qrs12
WHERE rnng_crr1 > -0.1
AND ydate > sysdate - 4/24
AND ABS(rscore_diff2) > 0.1
ORDER BY pair,ydate
/

exit
