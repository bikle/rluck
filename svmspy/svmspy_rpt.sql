--
-- svmspy_rpt.sql
--

-- I use this report to help me find any tkrs with nice CORR() between scores and gains.

-- I start by joining scores and gains for each tkr.

CREATE OR REPLACE VIEW sspy10 AS
SELECT
l.tkr
,l.score score_long
,s.score score_short
,gain1day g1d
,l.ydate
,ROUND(l.score,1)rscore_long
,ROUND(s.score,1)rscore_short
FROM stkscores l, stkscores s, di5min_stk_c2 g
WHERE l.targ='gatt'AND s.targ='gattn'
AND l.tkrdate=s.tkrdate
AND l.tkrdate=g.tkrdate
/

-- rpt
SELECT
tkr
,crr_l,crr_s
,mn_date
,ccount
,mx_date
FROM
(
  SELECT
  tkr
  ,CORR(score_long,g1d)crr_l
  ,CORR(score_short,g1d)crr_s
  ,MIN(ydate)mn_date
  ,COUNT(tkr)ccount
  ,MAX(ydate)mx_date
  FROM sspy10
  GROUP BY tkr
)
/

SELECT
tkr
,rscore_long
,AVG(g1d)
,COUNT(g1d)
FROM sspy10
GROUP BY tkr,rscore_long
ORDER BY tkr,rscore_long
/

SELECT
tkr
,rscore_short
,AVG(g1d)
,COUNT(g1d)
FROM sspy10
GROUP BY tkr,rscore_short
ORDER BY tkr,rscore_short
/

-- This works better for sparse results:

CREATE OR REPLACE VIEW sspy10l AS
SELECT
l.tkr
,l.score score_long
,gain1day g1d
,l.ydate
,ROUND(l.score,1)rscore_long
FROM stkscores l, di5min_stk_c2 g
WHERE l.targ='gatt'
AND l.tkrdate=g.tkrdate
/

SELECT
tkr
,ccount
,crr_l
FROM
(
  SELECT
  tkr
  ,CORR(score_long,g1d)crr_l
  ,MIN(ydate)mn_date
  ,COUNT(tkr)ccount
  ,MAX(ydate)mx_date
  FROM sspy10l
  GROUP BY tkr
)
/

SELECT
tkr
,rscore_long
,AVG(g1d)
,COUNT(g1d)
FROM sspy10l
GROUP BY tkr,rscore_long
ORDER BY tkr,rscore_long
/


CREATE OR REPLACE VIEW sspy10s AS
SELECT
l.tkr
,l.score score_short
,gain1day g1d
,l.ydate
,ROUND(l.score,1)rscore_short
FROM stkscores l, di5min_stk_c2 g
WHERE l.targ='gattn'
AND l.tkrdate=g.tkrdate
/

SELECT
tkr
,ccount
,crr_l
FROM
(
  SELECT
  tkr
  ,CORR(score_short,g1d)crr_l
  ,MIN(ydate)mn_date
  ,COUNT(tkr)ccount
  ,MAX(ydate)mx_date
  FROM sspy10s
  GROUP BY tkr
)
/

SELECT
tkr
,rscore_short
,AVG(g1d)
,COUNT(g1d)
FROM sspy10s
GROUP BY tkr,rscore_short
ORDER BY tkr,rscore_short
/

exit

