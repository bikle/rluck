--
-- qry_recent_stkscores.sql
--

-- I use this script to see which tkrdates have been scored recently.

SELECT * FROM ystkscores WHERE rundate> sysdate -0.5/24 ORDER BY rundate;

exit
