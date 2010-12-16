--
-- qry_recent_fxscores.sql
--

SELECT * FROM fxscores       WHERE rundate> sysdate -1 ORDER BY rundate;
SELECT * FROM fxscores_gattn WHERE rundate> sysdate -1 ORDER BY rundate;

exit
