--
-- qry_recent_stkscores.sql
--

-- I use this script to see which tkrdates have been scored recently.

SELECT * FROM stkscores WHERE rundate> sysdate -1/24 ORDER BY rundate;

exit
