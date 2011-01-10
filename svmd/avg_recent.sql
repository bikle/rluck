--
-- avg_recent.sql
--

SELECT
g.tkr
,AVG(l.score)score_long
,AVG(s.score)score_short
FROM ystkscores l, ystkscores s, good_tkrs_svmd g
WHERE s.tkr = g.tkr
AND s.tkrdate = l.tkrdate
AND s.targ = 'gattn'
AND l.targ = 'gatt'
AND l.rundate > sysdate - 1
GROUP BY g.tkr
ORDER BY g.tkr
/

exit
