--
-- score_corr.sql
--

-- I use this script to help me see recent CORR() between score and gain.

-- I start by getting the 1 day gain for each tkrdate.
CREATE OR REPLACE VIEW scc10svmspy AS
SELECT
tkrdate
,tkr
,ydate
,gain1day g1
FROM di5min_stk_c2
WHERE ydate > sysdate - 8
ORDER BY tkr,ydate
/

-- rpt
SELECT tkr,AVG(g1)FROM scc10svmspy GROUP BY tkr

CREATE OR REPLACE VIEW scc12svmspy AS
SELECT
m.tkr
,m.ydate
,m.tkrdate
,l.score score_long
,s.score score_short
,m.g1
FROM stkscores l,stkscores s,scc10svmspy m
WHERE l.targ='gatt'
AND   s.targ='gattn'
AND l.tkrdate = s.tkrdate
AND l.tkrdate = m.tkrdate
-- Speed things up:
AND l.ydate > sysdate - 8
AND s.ydate > sysdate - 8
/

CREATE OR REPLACE VIEW score_corr_svmspy AS
SELECT
tkr
,CORR((score_long - score_short),g1)score_corr
,COUNT(g1)ccount
FROM scc12svmspy
WHERE ydate > sysdate -8
GROUP BY tkr
ORDER BY CORR((score_long - score_short),g1)
/

SELECT * FROM score_corr_svmspy;

-- exit

