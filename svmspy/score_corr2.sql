--
-- score_corr2.sql
--

-- I use this script to help me see recent CORR() between score and gain.
-- This script is inspired by score_corr.sql
-- This script differs in that it calculates CORR() in an analytic function
-- rather than inside an aggregation-query.

-- The main reason I want to see recent CORR() is to determine which stocks I will repeatedly score each day.
-- Currently I dont have enough CPU to repeatedly score 160 tkrs.
-- Currently I can repeatedly score 10 to 30 tkrs.

-- I start by getting the 1 day gain for each tkrdate.

DROP TABLE scc10svmspy_t;
CREATE TABLE scc10svmspy_t COMPRESS AS
SELECT
tkrdate
,tkr
,ydate
,gain1day g1
FROM di5min_stk_c2
WHERE ydate > sysdate - 100
ORDER BY tkr,ydate
/

DROP TABLE scc12svmspy_t;
CREATE TABLE scc12svmspy_t COMPRESS AS
SELECT
m.tkr
,m.ydate
,m.tkrdate
,l.score score_long
,s.score score_short
,l.score - s.score score_diff
,ROUND((l.score-s.score),1)rscore_diff
,m.g1
FROM stkscores l,stkscores s,scc10svmspy_t m
WHERE l.targ='gatt'
AND   s.targ='gattn'
AND l.tkrdate = s.tkrdate
AND l.tkrdate = m.tkrdate
-- Speed things up:
AND l.ydate > sysdate - 100
AND s.ydate > sysdate - 100
/

DROP TABLE scc14svmspy_t;
CREATE TABLE scc14svmspy_t COMPRESS AS
SELECT
tkr
,ydate
,score_diff
,ROUND(score_diff,2)rscore_diff
,g1
,CORR(score_diff,g1)OVER(PARTITION BY tkr ORDER BY ydate ROWS BETWEEN 8*12*6.5 PRECEDING AND CURRENT ROW)mvg_sc_crr
FROM scc12svmspy_t
ORDER BY tkrdate
/

-- rpt
select min(ydate),count(tkr),max(ydate)from scc14svmspy_t where tkr='SPY';

select count(*)from
(
SELECT
ydate
,tkr
,rscore_diff
,g1
,mvg_sc_crr
FROM scc14svmspy_t
WHERE ydate > sysdate - 4
AND ABS(score_diff) > 0.6
AND mvg_sc_crr > 0.1
ORDER BY ydate,tkr
)
/

SELECT
ydate
,tkr
,rscore_diff
,g1
,mvg_sc_crr
FROM scc14svmspy_t
WHERE ydate > sysdate - 4
AND ABS(score_diff) > 0.6
AND mvg_sc_crr > 0.1
ORDER BY ydate,tkr
/

SELECT DISTINCT tkr FROM
(
SELECT
ydate
,tkr
,rscore_diff
,g1
,mvg_sc_crr
FROM scc14svmspy_t
WHERE ydate > sysdate - 11
AND ABS(score_diff) > 0.6
AND mvg_sc_crr > 0.1
ORDER BY ydate,tkr
)
/

PURGE RECYCLEBIN;

exit

-- I display syntax from score_corr.sql below for reference:

CREATE OR REPLACE VIEW score_corr_svmspy AS
SELECT
tkr
,CORR(score_diff,g1)score_corr
,MIN(ydate)min_date
,COUNT(g1)ccount
,MAX(ydate)max_date
FROM scc12svmspy
WHERE ydate > sysdate - 8
GROUP BY tkr
ORDER BY CORR(score_diff,g1) DESC
/

SELECT * FROM score_corr_svmspy

SELECT * FROM score_corr_svmspy
WHERE ccount > 9
AND max_date > sysdate - 3
AND score_corr > 0.0
/

-- exit

