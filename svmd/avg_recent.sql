--
-- avg_recent.sql
--

SELECT
l.tkr
,AVG(l.score)score_long
,AVG(s.score)score_short
,COUNT(l.tkr)ccount
,MAX(l.ydate)mx_ydate
FROM ystkscores l, ystkscores s
WHERE s.tkrdate = l.tkrdate
AND s.targ = 'gattn'
AND l.targ = 'gatt'
AND l.ydate > sysdate - 2
GROUP BY l.tkr
ORDER BY l.tkr
/

exit
