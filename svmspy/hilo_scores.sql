--
-- hilo_scores.sql
--

-- I use this script to aggregate recent scores.
-- I intend to look at output from this script before I open positions.


COLUMN clse  FORMAT 999.9999

SELECT
tkrdate
,ROUND(score_long,2) score_long
,ROUND(score_short,2)score_short
,rundate
,ROUND(clse,4)clse 
,CASE WHEN TO_CHAR(ydate,'dy')='fri'THEN ydate + 3
      WHEN TO_CHAR(ydate,'dy')IN
        ('mon','tue','wed','thu')   THEN ydate + 1
      ELSE NULL END clse_date
FROM ocj_stk
WHERE ydate > sysdate - 3/24
AND (score_long > 0.8 OR score_short > 0.8)
ORDER BY tkr,ydate
/

exit
