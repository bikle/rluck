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
WHERE ydate > sysdate - 123
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
AND l.ydate > sysdate - 123
AND s.ydate > sysdate - 123
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
WHERE ydate > sysdate - 123
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

-- See aggregation:

COLUMN avg_clse     FORMAT 999.99
COLUMN avg_g1       FORMAT 999.99
COLUMN stddev_g1    FORMAT 999.99
COLUMN sharpe_ratio FORMAT 99.99
COLUMN sum_g1       FORMAT 9999.99

SELECT
SIGN(score_diff) sign_score_diff
,tkr
,AVG(clse)  avg_clse
,AVG(g1)    avg_g1
,AVG(g1)/STDDEV(g1) sharpe_ratio
,SUM(g1)    sum_g1
,MIN(ydate) min_ydate
,COUNT(g1)  count_g1
,MAX(ydate) max_ydate
FROM us_stk_pst12
WHERE ydate > sysdate - 123
AND rnng_crr1 > 0.1
AND ABS(rscore_diff2) > 0.6
GROUP BY SIGN(score_diff),tkr
HAVING STDDEV(g1)>0 AND COUNT(g1)>9
ORDER BY SIGN(score_diff),tkr
/

SELECT
SIGN(score_diff) sign_score_diff
,tkr
,AVG(clse)  avg_clse
,AVG(g1)    avg_g1
,AVG(g1)/STDDEV(g1) sharpe_ratio
,SUM(g1)    sum_g1
,MIN(ydate) min_ydate
,COUNT(g1)  count_g1
,MAX(ydate) max_ydate
FROM us_stk_pst12
WHERE ydate > sysdate - 123
AND rnng_crr1 > 0.1
AND ABS(rscore_diff2) > 0.5
GROUP BY SIGN(score_diff),tkr
HAVING STDDEV(g1)>0 AND COUNT(g1)>9
ORDER BY SIGN(score_diff),tkr
/

-- relax rnng_crr1:

SELECT
SIGN(score_diff) sign_score_diff
,TO_CHAR(ydate,'WW')wk
,AVG(clse)  avg_clse
,AVG(g1)    avg_g1
,AVG(g1)/STDDEV(g1) sharpe_ratio
,SUM(g1)    sum_g1
,MIN(ydate) min_ydate
,COUNT(g1)  count_g1
,MAX(ydate) max_ydate
FROM us_stk_pst12
WHERE ydate > sysdate - 123
AND rnng_crr1 > -1
AND ABS(rscore_diff2) > 0.5
GROUP BY SIGN(score_diff),TO_CHAR(ydate,'WW')
HAVING STDDEV(g1)>0 AND COUNT(g1)>9
ORDER BY SIGN(score_diff),TO_CHAR(ydate,'WW')
/

-- constrain rnng_crr1:

SELECT
SIGN(score_diff) sign_score_diff
,TO_CHAR(ydate,'WW')wk
,AVG(clse)  avg_clse
,AVG(g1)    avg_g1
,AVG(g1)/STDDEV(g1) sharpe_ratio
,SUM(g1)    sum_g1
,MIN(ydate) min_ydate
,COUNT(g1)  count_g1
,MAX(ydate) max_ydate
FROM us_stk_pst12
WHERE ydate > sysdate - 123
AND rnng_crr1 > 0.0
AND ABS(rscore_diff2) > 0.5
GROUP BY SIGN(score_diff),TO_CHAR(ydate,'WW')
HAVING STDDEV(g1)>0 AND COUNT(g1)>9
ORDER BY SIGN(score_diff),TO_CHAR(ydate,'WW')
/

SELECT
SIGN(score_diff) sign_score_diff
,TO_CHAR(ydate,'WW')wk
,AVG(clse)  avg_clse
,AVG(g1)    avg_g1
,AVG(g1)/STDDEV(g1) sharpe_ratio
,SUM(g1)    sum_g1
,MIN(ydate) min_ydate
,COUNT(g1)  count_g1
,MAX(ydate) max_ydate
FROM us_stk_pst12
WHERE ydate > sysdate - 123
AND rnng_crr1 > 0.1
AND ABS(rscore_diff2) > 0.5
GROUP BY SIGN(score_diff),TO_CHAR(ydate,'WW')
HAVING STDDEV(g1)>0 AND COUNT(g1)>9
ORDER BY SIGN(score_diff),TO_CHAR(ydate,'WW')
/

-- See recent details:

SELECT
tkr
,ydate
,clse
,rscore_diff2
,g1
,rnng_crr1
FROM us_stk_pst12
-- WHERE ydate > sysdate - 3/24
WHERE ydate > '2011-04-26 17:33'
AND rnng_crr1 > 0.1
AND ABS(rscore_diff2) > 0.5
ORDER BY
tkr
,ydate
,clse
/


exit
