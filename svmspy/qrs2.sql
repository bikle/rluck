--
-- qrs2.sql
--

-- I use this script to query recent scores to help me open stock positions.

DROP TABLE us_stk_pst10;
PURGE RECYCLEBIN;
CREATE TABLE us_stk_pst10 COMPRESS AS
SELECT
tkr
,ydate
,tkrdate
,clse
,selldate
,gain1day g1
FROM di5min_stk_c2
WHERE ydate > sysdate - 9
ORDER BY tkr,ydate
/

ANALYZE TABLE us_stk_pst10 ESTIMATE STATISTICS SAMPLE 9 PERCENT;

DROP TABLE us_stk_pst12;
CREATE TABLE us_stk_pst12 COMPRESS AS
SELECT
m.tkr
,m.ydate
,m.clse
,(l.score-s.score)         score_diff
,ROUND(l.score-s.score,1) rscore_diff1
,ROUND(l.score-s.score,2) rscore_diff2
,m.g1
,CORR(l.score-s.score,m.g1)OVER(PARTITION BY l.tkr ORDER BY l.ydate ROWS BETWEEN 12*24*5 PRECEDING AND CURRENT ROW)rnng_crr1
FROM stkscores l,stkscores s,us_stk_pst10 m
WHERE l.targ='gatt'
AND   s.targ='gattn'
AND l.tkrdate = s.tkrdate
AND l.tkrdate = m.tkrdate
-- Speed things up:
AND l.ydate > sysdate - 9
AND s.ydate > sysdate - 9
/

ANALYZE TABLE us_stk_pst12 ESTIMATE STATISTICS SAMPLE 9 PERCENT;

select count(*)from
(
SELECT
tkr
,ydate
,clse
,rscore_diff2
,g1
,rnng_crr1
FROM us_stk_pst12
WHERE ydate > sysdate - 1
)
/

select count(*)from
(
SELECT
tkr
,ydate
,clse
,rscore_diff2
,g1
,rnng_crr1
FROM us_stk_pst12
WHERE ydate > sysdate - 1
AND rnng_crr1 > 0.1
AND ABS(rscore_diff2) > 0.6
)
/


SELECT
tkr
,ydate
,clse
,rscore_diff2
,g1
,rnng_crr1
FROM us_stk_pst12
WHERE ydate > sysdate - 1
AND rnng_crr1 > 0.1
AND ABS(rscore_diff2) > 0.6
ORDER BY
tkr
,ydate
,clse
/


exit
