--
-- avg_recent_good.sql
--


SELECT
l.tkr
,AVG(l.score)score_long
,AVG(s.score)score_short
,COUNT(l.tkr)ccount
,MAX(l.ydate)mx_ydate
FROM ystkscores l, ystkscores s, good_tkrs_svmd_v g
WHERE s.tkrdate = l.tkrdate
AND l.tkr = g.tkr
AND s.targ = 'gattn'
AND l.targ = 'gatt'
AND l.ydate > sysdate - 4
GROUP BY l.tkr
ORDER BY l.tkr
/



SELECT
l.tkr
,AVG(l.score)score_long
,AVG(s.score)score_short
,COUNT(l.tkr)ccount
,MAX(l.ydate)mx_ydate
FROM ystkscores l, ystkscores s, good_tkrs_svmd_v g
WHERE s.tkrdate = l.tkrdate
AND l.tkr = g.tkr
AND s.targ = 'gattn'
AND l.targ = 'gatt'
AND l.ydate > sysdate - 4
GROUP BY l.tkr
HAVING AVG(l.score) > 0.7
ORDER BY l.tkr
/

SELECT
l.tkr
,AVG(l.score)score_long
,AVG(s.score)score_short
,COUNT(l.tkr)ccount
,MAX(l.ydate)mx_ydate
FROM ystkscores l, ystkscores s, good_tkrs_svmd_v g
WHERE s.tkrdate = l.tkrdate
AND l.tkr = g.tkr
AND s.targ = 'gattn'
AND l.targ = 'gatt'
AND l.ydate > sysdate - 4
GROUP BY l.tkr
HAVING AVG(S.score) > 0.7
ORDER BY l.tkr
/



exit
