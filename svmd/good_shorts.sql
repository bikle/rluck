--
-- good_shorts.sql
--

-- I use this script to generate a list of tkrs which have a nice value of CORR() for short scores.

--rpt

SELECT COUNT(*)FROM ystk;

SELECT COUNT(*)FROM ystkscores;

-- Start by getting a join of scores and gains:
CREATE OR REPLACE VIEW svmd_gl AS
SELECT
l.tkr
,l.ydate
,l.score score_short
,ROUND(l.score,1) rscore_short
,g1d
FROM ystk y,ystkscores l
WHERE l.targ='gattn'
AND y.tkrdate = l.tkrdate
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
FROM svmd_gl
GROUP BY tkr
)
ORDER BY crr_s
/

SELECT * FROM svmd_gl_crr_s

-- Now join with recent scores:
SELECT
l.tkr
,l.ydate
,l.score score_short
,s.crr_s
FROM ystk y,ystkscores l,svmd_gl_crr_s s
WHERE l.targ='gattn'
AND y.tkrdate = l.tkrdate
AND l.ydate > sysdate - 6
AND l.score > 0.8
-- I want good past CORR():
AND s.crr_s < 0.0
AND l.tkr = s.tkr
/

exit


