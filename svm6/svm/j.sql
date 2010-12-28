--
-- qry_recent_fxscores.sql
--

SELECT
s.prdate
,score long_score
,gscore short_score
,rundate
,clse
FROM ocj s, di5min p
WHERE s.ydate = p.ydate
AND s.ydate > sysdate - 5/24
AND REPLACE(REPLACE(p.pair,'usd_',''),'_usd','') = s.pair
AND s.pair = 'eur'
ORDER BY s.ydate
/

exit
