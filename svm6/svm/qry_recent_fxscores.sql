--
-- qry_recent_fxscores.sql
--

-- I create ocj in ../openclose/avg_recent_scores.sql
-- done already:
-- CREATE OR REPLACE VIEW ocj AS ...

SELECT * FROM fxscores6       WHERE rundate> sysdate -0.5/24 ORDER BY ydate;

SELECT * FROM fxscores6_gattn WHERE rundate> sysdate -0.5/24 ORDER BY ydate;

SELECT * FROM fxscores6       WHERE rundate> sysdate -0.5/24 AND score > 0.7 ORDER BY ydate;

SELECT * FROM fxscores6_gattn WHERE rundate> sysdate -0.5/24 AND score > 0.7 ORDER BY ydate;

COLUMN clse  FORMAT 999.9999

SELECT
prdate
,score long_score
,gscore short_score
,rundate
,ROUND(clse,4)clse 
,ydate + 6/24 clse_date
FROM ocj
WHERE ydate > sysdate - 2/24
ORDER BY ydate
/

