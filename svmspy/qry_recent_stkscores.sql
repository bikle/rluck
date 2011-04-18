--
-- qry_recent_stkscores.sql
--

-- I use this script to see which tkrdates have been scored recently.

SELECT tkr,COUNT(tkr),max(ydate)FROM stkscores WHERE ydate > '2011-04-04'GROUP BY tkr ORDER BY tkr;

SELECT * FROM stkscores WHERE rundate> sysdate -1/24 ORDER BY rundate;

SELECT count(*) FROM stkscores WHERE tkr = 'HD' and rundate> sysdate -1/24;

exit
