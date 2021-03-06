--
-- qry_recent_stkscores.sql
--

-- I use this script to see which tkrdates have been scored recently.

SELECT * FROM stkscores WHERE rundate> sysdate -1/24 ORDER BY rundate

SELECT tkr,targ,AVG(score),COUNT(tkr),max(ydate)FROM stkscores WHERE ydate > sysdate-4/24 GROUP BY tkr,targ ORDER BY tkr,targ;

SELECT count(*) FROM stkscores WHERE rundate> sysdate -1/24;

exit
