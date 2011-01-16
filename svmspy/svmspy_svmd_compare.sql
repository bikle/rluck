--
-- svmspy_svmd_compare.sql
--

-- I use this script to help my compare svmspy and svmd.


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

CREATE OR REPLACE VIEW sspy12 AS
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

-- rpt
SELECT * FROM sspy12;

-- svmd_gl_crr_l is created here:
-- rluck/svmd/good_longs.sql

CREATE OR REPLACE VIEW svmd_gl_crr_l AS
SELECT * FROM
(
SELECT
tkr
,MIN(YDATE)mn_date
,COUNT(tkr)ccount
,MAX(YDATE)mx_date
,CORR(score_long,g1d)crr_l
FROM svmd_gl
WHERE ydate BETWEEN
  (SELECT MIN(ydate)FROM sspy10)
  AND
  (SELECT MAX(ydate)FROM sspy10)
GROUP BY tkr
)
/

CREATE OR REPLACE VIEW svmd_gl_crr_s AS
SELECT * FROM
(
SELECT
tkr
,MIN(YDATE)mn_date
,COUNT(tkr)ccount
,MAX(YDATE)mx_date
,CORR(score_short,g1d)crr_s
FROM svmd_gs
WHERE ydate BETWEEN
  (SELECT MIN(ydate)FROM sspy10)
  AND
  (SELECT MAX(ydate)FROM sspy10)
GROUP BY tkr
)
/

SELECT
p.tkr
,p.crr_l,p.crr_s
,p.mn_date
,p.ccount
,p.mx_date
,l.crr_l crr_l_svmd
,s.crr_s crr_s_svmd
FROM sspy12 p, svmd_gl_crr_l l, svmd_gl_crr_s s
WHERE p.tkr = l.tkr
AND   p.tkr = s.tkr
/


exit
