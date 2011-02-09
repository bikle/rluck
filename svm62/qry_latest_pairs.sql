--
-- qry_latest_pairs.sql
--

SELECT
pair
,MAX(ydate)
FROM di5min
GROUP BY pair
ORDER BY MAX(ydate)
/

exit
