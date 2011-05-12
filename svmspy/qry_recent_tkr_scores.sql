--
-- qry_recent_tkr_scores.sql
--

-- I use this script to look at recent scores for a specific tkr.
-- Usage: @qry_recent_tkr_scores SLV

-- This script depends on qrs2.sql running first.

-- @qrs2.sql

SELECT
tkr
,ydate
,ROUND(score_diff,2)score_diff
,ROUND(g1,2)        gain1day
,ROUND(rnng_crr1,2) rnng_crr1
FROM us_stk_pst12
WHERE ydate > sysdate - 2
AND tkr = '&1'
ORDER BY tkr,ydate
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
AND rnng_crr1 > -1
AND tkr = '&1'
GROUP BY SIGN(score_diff),tkr
HAVING STDDEV(g1)>0 AND COUNT(g1)>9
ORDER BY SIGN(score_diff),tkr
/

SELECT
SIGN(score_diff) sign_score_diff
,tkr
,CORR(score_diff,g1)
,COUNT(g1)  count_g1
FROM us_stk_pst12
WHERE ydate > sysdate - 123
AND rnng_crr1 > -1
AND tkr = '&1'
GROUP BY SIGN(score_diff),tkr
HAVING STDDEV(g1)>0 AND COUNT(g1)>9
ORDER BY SIGN(score_diff),tkr
/

exit
