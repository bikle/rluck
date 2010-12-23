--
-- qry_gain4recent_short.sql
--

-- I use this script as a prototype to query the gains for a pair
-- WHERE scores are high and scores are recent.

SELECT
'avg_g8'
||'matchthis'
,AVG(jpy_g8)
FROM fxscores8hp_gattn s, jpy_ms10 m
WHERE s.pair = 'jpy'
AND s.ydate = m.ydate
AND score > 0.7
AND s.ydate > sysdate - 1
HAVING COUNT(score) > 9
/

exit
