
COLUMN clse  FORMAT 999.9999

SELECT
prdate
,score long_score
,gscore short_score
,rundate
,ROUND(clse,4)clse 
,ydate + 6/24 clse_date
FROM ocj
WHERE ydate > sysdate - 8/24
AND pair = 'aud'
ORDER BY ydate
/

