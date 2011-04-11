--
-- qry_recent_stkscores.sql
--

-- I use this script to see which tkrdates have been scored recently.

SELECT tkr,COUNT(tkr)FROM stkscores WHERE ydate > '2011-04-04'GROUP BY tkr ORDER BY tkr;

SELECT * FROM stkscores WHERE rundate> sysdate -1/24 ORDER BY rundate;

exit
