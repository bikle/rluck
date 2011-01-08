--
-- qry_recent_svm62scores.sql
--

SELECT * FROM svm62scores WHERE rundate> sysdate -0.5/24 ORDER BY rundate;

COLUMN clse  FORMAT 999.9999

-- Not ready yet:
SELECT
prdate
,score long_score
,gscore short_score
,rundate
,ROUND(clse,4)clse 
,ydate + 6/24 clse_date
FROM ocj
WHERE ydate > sysdate - 2/24
ORDER BY rundate


