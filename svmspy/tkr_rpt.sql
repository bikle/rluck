--
-- tkr_rpt.sql
--

-- I use this script to report on correlation between SVM scores and Forex gains.

CREATE OR REPLACE VIEW tkr_rpt10 AS
SELECT
l.tkr
,l.score  score_long
,s.score score_short
,m.g4
,m.ydate
,ROUND(l.score,1)rscore_long
,ROUND(s.score,1)rscore_short
FROM stkscores l, stkscores s,stk_ms m
WHERE l.ydate = s.ydate
AND   l.ydate = m.ydate
AND l.tkr = s.tkr
AND l.tkr = m.tkr
AND l.targ = 'gatt'
AND s.targ = 'gattn'
/

-- rpt

SELECT COUNT(*)FROM stkscores;

SELECT COUNT(*)FROM tkr_rpt10;

-- Look for CORR():
SELECT
tkr
,MIN(ydate)
,COUNT(ydate)
,MAX(ydate)
,CORR(score_long, g4)
,CORR(score_short, g4)
FROM tkr_rpt10
GROUP BY tkr
/

-- Look at distribution of scores and resulting gains.
-- A hich score means SVM has high confidence that the long position will be lucrative:

SELECT
tkr
,MIN(ydate)
,COUNT(ydate)
,MAX(ydate)
,rscore_long
,ROUND(MIN(g4),3)min_g4
,ROUND(AVG(g4),3)avg_g4
,ROUND(STDDEV(g4),3)stddv_g4
,ROUND(MAX(g4),3)max_g4
FROM tkr_rpt10
GROUP BY tkr,rscore_long
ORDER BY tkr,rscore_long
/

-- Low score_short:

SELECT
tkr
,MIN(ydate)
,COUNT(ydate)
,MAX(ydate)
,rscore_long
,ROUND(MIN(g4),3)min_g4
,ROUND(AVG(g4),3)avg_g4
,ROUND(STDDEV(g4),3)stddv_g4
,ROUND(MAX(g4),3)max_g4
FROM tkr_rpt10
WHERE rscore_short < 0.3
GROUP BY tkr,rscore_long
ORDER BY tkr,rscore_long
/


-- Now go looking for high scores for shorts:

SELECT
tkr
,MIN(ydate)
,COUNT(ydate)
,MAX(ydate)
,rscore_short
,ROUND(MIN(g4),3)min_g4
,ROUND(AVG(g4),3)avg_g4
,ROUND(STDDEV(g4),3)stddv_g4
,ROUND(MAX(g4),3)max_g4
FROM tkr_rpt10
GROUP BY tkr,rscore_short
ORDER BY tkr,rscore_short
/

-- Now I combine high rscore_short and low rscore_long:

SELECT
tkr
,MIN(ydate)
,COUNT(ydate)
,MAX(ydate)
,rscore_short
,ROUND(MIN(g4),3)min_g4
,ROUND(AVG(g4),3)avg_g4
,ROUND(STDDEV(g4),3)stddv_g4
,ROUND(MAX(g4),3)max_g4
FROM tkr_rpt10
WHERE rscore_long < 0.3
GROUP BY tkr,rscore_short
ORDER BY tkr,rscore_short
/

-- This works better on sparse results:


CREATE OR REPLACE VIEW tkr_rpt_long AS
SELECT
m.tkr
,l.score  score_long
,m.g4
,m.ydate
,ROUND(l.score,1)rscore_long
FROM stkscores l,stk_ms m
WHERE l.ydate = m.ydate
AND l.tkr = m.tkr
AND l.targ = 'gatt'
/


-- Look for CORR():
SELECT
tkr
,MIN(ydate)
,COUNT(ydate)
,MAX(ydate)
,CORR(score_long, g4)
FROM tkr_rpt_long
GROUP BY tkr
/

-- Look at distribution of scores and resulting gains.
-- A hich score means SVM has high confidence that the long position will be lucrative:

SELECT
tkr
,MIN(ydate)
,COUNT(ydate)
,MAX(ydate)
,rscore_long
,ROUND(MIN(g4),3)min_g4
,ROUND(AVG(g4),3)avg_g4
,ROUND(STDDEV(g4),3)stddv_g4
,ROUND(MAX(g4),3)max_g4
FROM tkr_rpt_long
GROUP BY tkr,rscore_long
ORDER BY tkr,rscore_long
/

-- Look at shorts:

CREATE OR REPLACE VIEW tkr_rpt_short AS
SELECT
m.tkr
,s.score  score_short
,m.g4
,m.ydate
,ROUND(s.score,1)rscore_short
FROM stkscores s,stk_ms m
WHERE s.ydate = m.ydate
AND s.tkr = m.tkr
AND s.targ = 'gattn'
/


-- Look for CORR():
SELECT
tkr
,MIN(ydate)
,COUNT(ydate)
,MAX(ydate)
,CORR(score_short, g4)
FROM tkr_rpt_short
GROUP BY tkr
/


-- Look at distribution of scores and resulting gains.
-- A hich score means SVM has high confidence that the short position will be lucrative:

SELECT
tkr
,MIN(ydate)
,COUNT(ydate)
,MAX(ydate)
,rscore_short
,ROUND(MIN(g4),3)min_g4
,ROUND(AVG(g4),3)avg_g4
,ROUND(STDDEV(g4),3)stddv_g4
,ROUND(MAX(g4),3)max_g4
FROM tkr_rpt_short
GROUP BY tkr,rscore_short
ORDER BY tkr,rscore_short
/

exit
