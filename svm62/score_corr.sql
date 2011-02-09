--
-- score_corr.sql
--

-- I use this script to help me see recent CORR() between score and gain.

-- I use this script to see corr_of_corr:
-- @corrocorr.sql

-- I start by getting the 6 hr gain for each prdate.
CREATE OR REPLACE VIEW scc10 AS
SELECT
prdate
,pair
,ydate
,(LEAD(clse,12*6,NULL)OVER(PARTITION BY pair ORDER BY ydate)-clse)/clse g6
FROM di5min
-- WHERE ydate BETWEEN(sysdate - 34)AND'2011-01-14'
WHERE ydate > sysdate - 122
AND clse > 0
ORDER BY pair,ydate
/

-- rpt
SELECT
pair
,AVG(g6)
,MIN(ydate)
,COUNT(ydate)
,MAX(ydate)
FROM scc10
GROUP BY pair
ORDER BY pair
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
,m.g6
FROM svm62scores l,svm62scores s,scc10 m
WHERE l.targ='gatt'
AND   s.targ='gattn'
AND l.prdate = s.prdate
AND l.prdate = m.prdate
-- Speed things up:
AND l.ydate > sysdate - 133
AND s.ydate > sysdate - 133
/

SELECT
pair
,rscore_long
,AVG(g6)
,COUNT(pair)ccount
FROM scc12
WHERE ydate > sysdate - 3
GROUP BY pair,rscore_long
ORDER BY pair,rscore_long
/

SELECT
pair
,rscore_short
,AVG(g6)
,COUNT(pair)ccount
FROM scc12
WHERE ydate > sysdate - 3
GROUP BY pair,rscore_short
ORDER BY pair,rscore_short


SELECT
pair
,rscore_diff
,AVG(g6)
,COUNT(pair)ccount
FROM scc12
WHERE ydate > sysdate - 3
GROUP BY pair,rscore_diff
ORDER BY pair,rscore_diff

SELECT
pair
,CORR(score_long,g6)score_corr_l
,CORR(score_short,g6)score_corr_s
,CORR(score_diff,g6)score_corr_d
,MIN(ydate)
,COUNT(pair)ccount
,MAX(ydate)
FROM scc12
WHERE ydate > sysdate - 66
GROUP BY pair 
ORDER BY pair 
/

SELECT
pair
,CORR(score_long,g6)score_corr_l
,CORR(score_short,g6)score_corr_s
,CORR(score_diff,g6)score_corr_d
,MIN(ydate)
,COUNT(pair)ccount
,MAX(ydate)
FROM scc12
WHERE ydate > sysdate - 3
GROUP BY pair 
ORDER BY pair 
/

SELECT
pair
,CORR(score_long,g6)score_corr_l
,CORR(score_short,g6)score_corr_s
,CORR(score_diff,g6)score_corr_d
,MIN(ydate)
,COUNT(pair)ccount
,MAX(ydate)
FROM scc12
WHERE ydate > sysdate - 2
GROUP BY pair 
ORDER BY pair 
/

SELECT
pair
,CORR(score_long,g6)score_corr_l
,CORR(score_short,g6)score_corr_s
,CORR(score_diff,g6)score_corr_d
,MIN(ydate)
,COUNT(pair)ccount
,MAX(ydate)
FROM scc12
WHERE ydate > sysdate - 1
GROUP BY pair 
ORDER BY pair 
/

exit

