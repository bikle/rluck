--
-- good_longs.sql
--

-- I use this script to generate a list of tkrs which have a nice value of CORR() for long scores.

--rpt

SELECT COUNT(*)FROM ystk;

SELECT COUNT(*)FROM ystkscores;

-- Start by getting a join of scores and gains:
CREATE OR REPLACE VIEW svmd_gl AS
SELECT
l.tkr
,l.ydate
,l.score score_long
,ROUND(l.score,1) rscore_long
,g1d
FROM ystk y,ystkscores l
WHERE l.targ='gatt'
AND y.tkrdate = l.tkrdate
/

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
GROUP BY tkr
)
ORDER BY crr_l
/

SELECT * FROM svmd_gl_crr_l;

-- Now join with recent scores:
SELECT
l.tkr
,l.ydate
,l.score score_long
,s.crr_l
FROM ystk y,ystkscores l,svmd_gl_crr_l s
WHERE l.targ='gatt'
AND y.tkrdate = l.tkrdate
AND l.ydate > sysdate - 2
AND l.score > 0.7
-- I want good past CORR():
AND s.crr_l > 0.01
AND l.tkr = s.tkr
ORDER BY l.score
/




exit


