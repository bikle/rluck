--
-- spy_rpt.sql
--

-- I use this script to report on correlation between SVM scores and Forex gains.

CREATE OR REPLACE VIEW spy_rpt10 AS
SELECT
l.score  score_long
,s.score score_short
,m.g4
,m.ydate
,ROUND(l.score,1)rscore_long
,ROUND(s.score,1)rscore_short
FROM stkscores l,stkscores_gattn s,stk_ms m
WHERE l.ydate = s.ydate
AND   l.ydate = m.ydate
AND l.tkr = 'SPY'
AND l.tkr = s.tkr
/

-- rpt

SELECT COUNT(*)FROM stkscores;

SELECT COUNT(*)FROM stkscores_gattn;

SELECT COUNT(*)FROM spy_rpt10;

-- Look for CORR():
SELECT
MIN(ydate)
,COUNT(ydate)
,MAX(ydate)
,CORR(score_long, g4)
,CORR(score_short, g4)
FROM spy_rpt10
/

-- Look at distribution of scores and resulting gains.
-- A hich score means SVM has high confidence that the long position will be lucrative:

SELECT
MIN(ydate)
,COUNT(ydate)
,MAX(ydate)
,rscore_long
,ROUND(AVG(g4),3)avg_g4
FROM spy_rpt10
GROUP BY rscore_long
ORDER BY rscore_long
/

-- Look at distribution of scores and resulting gains,
-- Where SVM has low confidence the position will be a lucrative short:

SELECT
MIN(ydate)
,COUNT(ydate)
,MAX(ydate)
,rscore_long
,ROUND(AVG(g4),3)avg_g4
FROM spy_rpt10
WHERE rscore_short < 0.2
GROUP BY rscore_long
ORDER BY rscore_long
/

-- Now go looking for high scores for shorts:


SELECT
MIN(ydate)
,COUNT(ydate)
,MAX(ydate)
,rscore_short
,ROUND(AVG(g4),3)avg_g4
FROM spy_rpt10
GROUP BY rscore_short
ORDER BY rscore_short
/

SELECT
MIN(ydate)
,COUNT(ydate)
,MAX(ydate)
,rscore_short
,ROUND(AVG(g4),3)avg_g4
FROM spy_rpt10
WHERE rscore_long < 0.2
GROUP BY rscore_short
ORDER BY rscore_short
/
