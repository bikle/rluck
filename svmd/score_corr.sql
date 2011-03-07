--
-- score_corr.sql
--

-- I use this script to help me see recent CORR() between score and gain.

-- I start by getting the 1 day gain for each tkrdate.
CREATE OR REPLACE VIEW scc10svmd AS
SELECT
tkrdate
,tkr
,ydate
,LEAD(clse,1,NULL)OVER(PARTITION BY tkr ORDER BY ydate)-clse g1
FROM ystk
WHERE ydate > sysdate - 800
ORDER BY tkr,ydate
/

-- rpt
SELECT tkr,AVG(g1)FROM scc10svmd GROUP BY tkr

CREATE OR REPLACE VIEW scc12svmd AS
SELECT
m.tkr
,m.ydate
,m.tkrdate
,l.score score_long
,s.score score_short
,l.score - s.score score_diff
,ROUND(l.score,1) rscore_long
,ROUND(s.score,1) rscore_short
,ROUND((l.score-s.score),1)rscore_diff
,m.g1
FROM ystkscores l,ystkscores s,scc10svmd m
WHERE l.targ='gatt'
AND   s.targ='gattn'
AND l.tkrdate = s.tkrdate
AND l.tkrdate = m.tkrdate
-- Speed things up:
AND l.ydate > sysdate - 800
AND s.ydate > sysdate - 800
/

CREATE OR REPLACE VIEW score_corr_svmd AS
SELECT
tkr
,CORR(score_diff,g1)score_corr
,MIN(ydate)min_date
,COUNT(g1)ccount
,MAX(ydate)max_date
FROM scc12svmd
WHERE ydate > sysdate -800
GROUP BY tkr
ORDER BY CORR(score_diff,g1)
/

SELECT * FROM score_corr_svmd WHERE tkr='SPY';

SELECT
tkr
,rscore_diff
,AVG(g1)
,COUNT(g1)
FROM scc12svmd
WHERE tkr='SPY'
GROUP BY tkr,rscore_diff
ORDER BY tkr,rscore_diff
/

-- exit

