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
FROM stkscores l, stkscores s,stk_ms m
WHERE l.ydate = s.ydate
AND   l.ydate = m.ydate
AND l.tkr = 'SPY'
AND l.tkr = s.tkr
AND l.targ = 'gatt'
AND s.targ = 'gattn'
/

-- rpt

SELECT COUNT(*)FROM stkscores;

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
,ROUND(MIN(g4),3)min_g4
,ROUND(AVG(g4),3)avg_g4
,ROUND(STDDEV(g4),3)stddv_g4
,ROUND(MAX(g4),3)max_g4
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
,ROUND(MIN(g4),3)min_g4
,ROUND(AVG(g4),3)avg_g4
,ROUND(STDDEV(g4),3)stddv_g4
,ROUND(MAX(g4),3)max_g4
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
,ROUND(MIN(g4),3)min_g4
,ROUND(AVG(g4),3)avg_g4
,ROUND(STDDEV(g4),3)stddv_g4
,ROUND(MAX(g4),3)max_g4
FROM spy_rpt10
GROUP BY rscore_short
ORDER BY rscore_short
/

SELECT
MIN(ydate)
,COUNT(ydate)
,MAX(ydate)
,rscore_short
,ROUND(MIN(g4),3)min_g4
,ROUND(AVG(g4),3)avg_g4
,ROUND(STDDEV(g4),3)stddv_g4
,ROUND(MAX(g4),3)max_g4
FROM spy_rpt10
WHERE rscore_long < 0.2
GROUP BY rscore_short
ORDER BY rscore_short
/
