--
-- qry_ystk.sql
--

SELECT
tkr
,MIN(ydate)
,COUNT(ydate)
,MAX(ydate)
FROM ystk
GROUP BY tkr
ORDER BY MAX(ydate)
/

exit
