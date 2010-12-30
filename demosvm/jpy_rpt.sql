--
-- jpy_rpt.sql
--

-- I use this script to report on correlation between SVM scores and Forex gains.

CREATE OR REPLACE VIEW jpy_rpt10 AS
SELECT
l.score  score_long
,s.score score_short
,m.g6
,m.ydate
,ROUND(l.score,1)rscore_long
,ROUND(s.score,1)rscore_short
FROM fxscores_demo l,fxscores_demo_gattn s,jpy_ms m
WHERE l.ydate = s.ydate
AND   l.ydate = m.ydate
/

-- rpt

SELECT COUNT(*)FROM fxscores_demo;

SELECT COUNT(*)FROM fxscores_demo_gattn;

SELECT COUNT(*)FROM jpy_rpt10;

-- Look for CORR():
SELECT
COUNT(ydate)
,CORR(score_long, g6)
,CORR(score_short, g6)
FROM jpy_rpt10
/

-- Look at distribution of scores and resulting gains.
-- A hich score means SVM has high confidence that the long position will be lucrative:

SELECT
COUNT(ydate)
,rscore_long
,ROUND(AVG(g6),3)avg_g6
FROM jpy_rpt10
GROUP BY rscore_long
ORDER BY rscore_long
/

-- Look at distribution of scores and resulting gains,
-- Where SVM has low confidence the position will be a lucrative short:

SELECT
COUNT(ydate)
,rscore_long
,ROUND(AVG(g6),3)avg_g6
FROM jpy_rpt10
WHERE rscore_short < 0.2
GROUP BY rscore_long
ORDER BY rscore_long
/

-- Now go looking for high scores for shorts:


SELECT
COUNT(ydate)
,rscore_short
,ROUND(AVG(g6),3)avg_g6
FROM jpy_rpt10
GROUP BY rscore_short
ORDER BY rscore_short
/

SELECT
COUNT(ydate)
,rscore_short
,ROUND(AVG(g6),3)avg_g6
FROM jpy_rpt10
WHERE rscore_long < 0.2
GROUP BY rscore_short
ORDER BY rscore_short
/
