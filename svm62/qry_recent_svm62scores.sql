--
-- qry_recent_svm62scores.sql
--

SELECT * FROM svm62scores WHERE rundate> sysdate -0.5/24 ORDER BY rundate;

COLUMN clse  FORMAT 999.9999

SELECT
prdate
,score_long
,score_short
,rundate
,ROUND(clse,4)clse 
,ydate + 6/24 clse_date
FROM ocj
WHERE ydate > sysdate - 1/24
ORDER BY prdate
/

exit


