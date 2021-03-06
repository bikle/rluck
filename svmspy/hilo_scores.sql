--
-- hilo_scores.sql
--

-- I use this script to aggregate recent scores.
-- I intend to look at output from this script before I open positions.


COLUMN tkrdate  FORMAT A25
COLUMN clse  FORMAT 999.99
COLUMN diff  FORMAT 99.99
COLUMN score_l  FORMAT 99.9999
COLUMN score_s  FORMAT 99.9999
COLUMN score_corr  FORMAT 99.999999

-- Get recent CORR()tween score and g1:
@score_corr.sql

SELECT
tkrdate
,ROUND(score_long,2) score_l
,ROUND(score_short,2)score_s
,ROUND(score_long-score_short,2)diff
,CASE WHEN(score_long - score_short)>0.5 THEN'buy'
      WHEN(score_short - score_long)>0.5 THEN'sell'
      ELSE NULL END b_or_s
,rundate
,ROUND(clse,4)clse 
,CASE WHEN TO_CHAR(ydate,'dy')='fri'THEN ydate + 3
      WHEN TO_CHAR(ydate,'dy')IN
        ('mon','tue','wed','thu')   THEN ydate + 1
      ELSE NULL END clse_date
,score_corr
FROM ocj_stk o,score_corr_svmspy s
WHERE ydate > sysdate - 5/24
AND (score_long > 0.8 OR score_short > 0.8)
AND o.tkr = s.tkr
AND score_corr > 0.1
ORDER BY o.tkr,ydate
/

exit
