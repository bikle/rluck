--
-- avg_recent_scores.sql
--

-- I use this script to aggregate recent scores.
-- I intend to look at output from this script before I open positions.

-- I start by getting the 1 day gain for each tkrdate.
CREATE OR REPLACE VIEW scc10svmd AS
SELECT
tkrdate
,tkr
,ydate
,clse
,LEAD(clse,1,NULL)OVER(PARTITION BY tkr ORDER BY ydate)-clse g1
FROM ystk
WHERE ydate > sysdate - 800
ORDER BY tkr,ydate
/

-- Now join with scores:

CREATE OR REPLACE VIEW scc12svmd AS
SELECT
m.tkrdate
,m.tkr
,m.ydate
,m.clse
,l.score score_long
,s.score score_short
,l.score - s.score score_diff
,l.rundate
,ROUND(l.score,1) rscore_long
,ROUND(s.score,1) rscore_short
,ROUND((l.score-s.score),1)rscore_diff
,m.g1
,CASE WHEN TO_CHAR(m.ydate,'dy')='fri'THEN m.ydate + 3
      WHEN TO_CHAR(m.ydate,'dy')IN
        ('mon','tue','wed','thu')   THEN m.ydate + 1
      ELSE NULL END clse_date
FROM ystkscores l,ystkscores s,scc10svmd m
WHERE l.targ='gatt'
AND   s.targ='gattn'
AND l.tkrdate = s.tkrdate
AND l.tkrdate = m.tkrdate
-- Speed things up:
AND l.ydate > sysdate - 800
AND s.ydate > sysdate - 800
/

-- Mix-in score-correlation:

CREATE OR REPLACE VIEW ars10 AS
SELECT
tkrdate
,tkr
,ydate
,clse
,score_long
,score_short
,score_diff
,clse_date
,CORR(score_diff,g1)OVER(PARTITION BY tkr ORDER BY ydate ROWS BETWEEN 66 PRECEDING AND CURRENT ROW)sc_corr
FROM scc12svmd
ORDER BY tkr,ydate
/

-- rpt

SELECT
tkr
,score_diff
,clse
,clse_date
,sc_corr
FROM ars10
WHERE ydate > sysdate -4
AND sc_corr > 0.2
AND ABS(score_diff) > 0.6
ORDER BY clse_date,score_diff
/

SELECT
CASE WHEN score_diff > 0.5 THEN'Buy'
     WHEN score_diff < -0.5 THEN'Sell  '
     ELSE NULL END action
,tkr
,score_diff
,clse
,clse_date
,sc_corr
FROM ars10
WHERE ydate > sysdate -4
AND sc_corr > 0.1
AND ABS(score_diff) > 0.5
ORDER BY clse_date,score_diff
/

exit

SELECT
tkr
,score_long
,score_short
,score_diff
,clse
,clse_date
,sc_corr
FROM ars10
WHERE ydate > sysdate -4
ORDER BY tkr,clse_date
/

exit
