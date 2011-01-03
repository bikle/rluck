
COLUMN clse  FORMAT 999.9999

SELECT
tkrdate
,score long_score
,gscore short_score
,rundate
,ROUND(clse,4)clse 
,ydate + 6/24 clse_date
FROM ocj_stk
WHERE ydate > sysdate - 2/24
ORDER BY tkr, ydate
/
