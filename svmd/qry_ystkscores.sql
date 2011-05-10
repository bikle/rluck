--
-- qry_ystkscores.sql
--

SELECT
tkr
,MIN(ydate)
,COUNT(ydate)
,MAX(ydate)
FROM ystkscores
GROUP BY tkr
ORDER BY MAX(ydate),tkr
/

exit
