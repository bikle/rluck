--
-- qry_recent_prices.sql
--

SELECT tkr,clse,maxdate FROM
  (SELECT tkr||MAX(ydate)tkrdate , MAX(ydate) maxdate FROM ibs5min GROUP BY tkr) a
  ,ibs5min b
WHERE tkr||ydate = tkrdate
AND ydate > sysdate - 4
ORDER BY maxdate,tkr
/

exit
