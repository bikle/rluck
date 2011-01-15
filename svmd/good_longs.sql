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

exit


