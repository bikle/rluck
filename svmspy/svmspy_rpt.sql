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
CORR(score_long,g1d)crr_l
,CORR(score_short,g1d)crr_s
,MIN(ydate)mn_date
,COUNT(tkr)ccount
,MAX(ydate)mx_date
FROM sspy10
/

exit

