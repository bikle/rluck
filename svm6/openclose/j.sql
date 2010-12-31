
COLUMN clse  FORMAT 999.9999

SELECT
s.prdate
,score long_score
,gscore short_score
,rundate
,ROUND(clse,4)clse 
,s.ydate + 6/24 clse_date
FROM ocj s, di5min p
WHERE s.ydate = p.ydate
AND s.ydate > sysdate - 4/24
AND REPLACE(REPLACE(p.pair,'usd_',''),'_usd','') = s.pair
AND s.pair = 'eur'
ORDER BY s.ydate
/

