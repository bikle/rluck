--
-- score_corr_eur_chf.sql
--

-- I use this script to help me see recent CORR() between score and gain.

-- I start by getting the 6 hr gain for each prdate.
CREATE OR REPLACE VIEW scc10 AS
SELECT
prdate
,pair
,ydate
,(LEAD(clse,12*6,NULL)OVER(PARTITION BY pair ORDER BY ydate)-clse)/clse g6
FROM di5min
WHERE ydate > sysdate - 33
AND pair = 'eur_chf'
ORDER BY pair,ydate
/

-- rpt
SELECT pair,MIN(g6),AVG(g6),COUNT(g6),MAX(g6),STDDEV(g6)FROM scc10 GROUP BY pair;

CREATE OR REPLACE VIEW scc12 AS
SELECT
m.pair
,m.ydate
,m.prdate
,l.score score_long
,s.score score_short
,l.score - s.score score_diff
,ROUND(l.score,1) rscore_long
,ROUND(s.score,1) rscore_short
,ROUND((l.score-s.score),1) rscore_diff
,m.g6
FROM svm62scores l,svm62scores s,scc10 m
WHERE l.targ='gatt'
AND   s.targ='gattn'
AND l.prdate = s.prdate
AND l.prdate = m.prdate
/

SELECT
pair
,CORR((score_diff),g6)score_corr2
FROM scc12
GROUP BY pair ORDER BY CORR((score_long - score_short),g6)
/


SELECT
pair
,rscore_long
,AVG(g6)
,MIN(ydate)
,COUNT(g6)
,MAX(ydate)
FROM scc12
GROUP BY pair,rscore_long
ORDER BY pair,rscore_long
/

SELECT
pair
,rscore_short
,AVG(g6)
,MIN(ydate)
,COUNT(g6)
,MAX(ydate)
FROM scc12
GROUP BY pair,rscore_short
ORDER BY pair,rscore_short
/

SELECT
pair
,rscore_diff
,AVG(g6)
,MIN(ydate)
,COUNT(g6)
,MAX(ydate)
FROM scc12
GROUP BY pair,rscore_diff
ORDER BY pair,rscore_diff
/

exit

