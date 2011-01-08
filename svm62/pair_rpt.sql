--
-- pair_rpt.sql
--

-- I use this script to report on a pair after a backtest.

CREATE OR REPLACE VIEW pr10 AS
SELECT
s.pair
,m.ydate
,targ
,g6
,score
,ROUND(score,1)rscore
FROM svm62scores s, modsrc m
WHERE s.prdate = m.prdate
/

SELECT
pair
,targ
,rscore
,ROUND(AVG(g6),4)avg_g6
,ROUND(STDDEV(g6),4)std_g6
,MIN(ydate)
,COUNT(ydate)
,MAX(ydate)
,ROUND(CORR(score,g6),2)corr_score_g6
FROM pr10
GROUP BY pair,targ,rscore
ORDER BY pair,targ,rscore
/

SELECT
pair
,targ
,ROUND(CORR(score,g6),2)corr_score_g6
FROM pr10
WHERE score > 0.7
GROUP BY pair,targ
ORDER BY pair,targ
/

SELECT
pair
,targ
,ROUND(CORR(score,g6),2)corr_score_g6
FROM pr10
WHERE score < 0.3
GROUP BY pair,targ
ORDER BY pair,targ
/

-- Mix scores:

CREATE OR REPLACE VIEW pr12 AS
SELECT
l.pair
,m.ydate
,g6
,l.score score_long
,s.score score_short
FROM svm62scores l, svm62scores s, modsrc m
WHERE l.prdate = m.prdate
AND   s.prdate = m.prdate
AND   l.targ = 'gatt'
AND   s.targ = 'gattn'
/

SELECT
pair
,MIN(ydate)
,COUNT(ydate)
,MAX(ydate)
,ROUND(AVG(g6),4)
FROM pr12
WHERE score_long > 0.7 AND score_short < 0.3
GROUP BY pair
/

SELECT
pair
,MIN(ydate)
,COUNT(ydate)
,MAX(ydate)
,ROUND(AVG(g6),4)
FROM pr12
WHERE score_short > 0.7 AND score_long < 0.3
GROUP BY pair
/
