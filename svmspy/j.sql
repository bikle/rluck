--
-- qry_recent_stkscores.sql
--

-- I use this script to see which tkrdates have been scored recently.

SELECT * FROM stkscores WHERE rundate> 
(select max(rundate)-0.2/24 from stkscores)
ORDER BY rundate;

exit
