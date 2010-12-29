--
-- qry_recent_fxscores.sql
--

-- I use this script to see which prdates have been scored recently.

SELECT * FROM fxscores_demo WHERE rundate> sysdate -0.5/24 ORDER BY rundate;

SELECT * FROM fxscores_demo_gattn WHERE rundate> sysdate -0.5/24 ORDER BY rundate;

exit
