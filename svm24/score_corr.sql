--
-- score_corr.sql
--

-- I use this script to help me see recent CORR() between score and gain.

-- I start by getting the 24 hr gain for each prdate.
CREATE OR REPLACE VIEW scc10 AS
SELECT
prdate
,pair
,ydate
,(LEAD(clse,12*24-3,NULL)OVER(PARTITION BY pair ORDER BY ydate)-clse)/clse g1
,LEAD(ydate,12*24-3,NULL)OVER(PARTITION BY pair ORDER BY ydate)-ydate date_diff
FROM di5min24
WHERE ydate > '2011-01-10'
AND clse > 0
ORDER BY pair,ydate
/

-- rpt

-- I should see a diff of 3 days on fri:

SELECT
pair
,TO_CHAR(ydate,'dy')dday
,AVG(g1)
,AVG(date_diff)
FROM scc10
WHERE ydate > sysdate - 9
GROUP BY pair,TO_CHAR(ydate,'dy')
ORDER BY pair,TO_CHAR(ydate,'dy')
/

CREATE OR REPLACE VIEW scc12 AS
SELECT
m.pair
,m.ydate
,m.prdate
,l.score score_long
,s.score score_short
,l.score-s.score score_diff
,ROUND(l.score,1) rscore_long
,ROUND(s.score,1) rscore_short
,ROUND((l.score-s.score),1) rscore_diff
,m.g1
FROM svm24scores l,svm24scores s,scc10 m
WHERE l.targ='gatt'
AND   s.targ='gattn'
AND l.prdate = s.prdate
AND l.prdate = m.prdate
-- Speed things up:
AND l.ydate > sysdate - 123
AND s.ydate > sysdate - 123
/

SELECT
pair
,rscore_long
,AVG(g1)
,COUNT(pair)ccount
FROM scc12
WHERE ydate > '2011-01-10'
GROUP BY pair,rscore_long
ORDER BY pair,rscore_long
/

SELECT
pair
,rscore_short
,AVG(g1)
,COUNT(pair)ccount
FROM scc12
WHERE ydate > '2011-01-10'
GROUP BY pair,rscore_short
ORDER BY pair,rscore_short
/

SELECT
pair
,rscore_diff
,AVG(g1)
,COUNT(pair)ccount
FROM scc12
WHERE ydate > '2011-01-10'
GROUP BY pair,rscore_diff
ORDER BY pair,rscore_diff
/

SELECT
pair
,CORR(score_diff,g1)score_corr2
,COUNT(pair)ccount
FROM scc12
WHERE ydate > '2011-01-10'
GROUP BY pair ORDER BY CORR(score_diff,g1)
/

exit

