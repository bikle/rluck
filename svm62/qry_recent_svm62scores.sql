--
-- qry_recent_svm62scores.sql
--

SELECT * FROM svm62scores WHERE rundate> sysdate -0.5/24 ORDER BY rundate

COLUMN clse  FORMAT 999.9999
COLUMN score_long  FORMAT 9.99
COLUMN score_short FORMAT 9.99
COLUMN dff         FORMAT 9.99

SELECT
prdate
,CASE WHEN(score_long-score_short > 0.5)THEN'buy'
      WHEN(score_short-score_long > 0.5)THEN'sell'
      ELSE null END b_or_s
,ROUND(score_long-score_short,2) dff
,ROUND(clse,4)clse 
,ROUND(score_long,2)score_long
,ROUND(score_short,2)score_short
,rundate
,ydate + 6/24 clse_date
FROM ocj
WHERE ydate > sysdate - 4/24
ORDER BY prdate
/

exit


