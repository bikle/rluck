--
-- avg_recent.sql
--

CREATE OR REPLACE VIEW svmd_ar AS
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
/

SELECT * FROM svmd_ar ORDER BY tkr;

SELECT * FROM svmd_ar
WHERE score_long > 0.7
OR    score_short > 0.7
ORDER BY score_long
/

exit
