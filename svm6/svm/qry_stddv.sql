--
-- qry_stddv.sql
--

-- I use this script to look at recent std deviations of prices

SELECT
pair
,ROUND(MIN(clse),4)
,ROUND(STDDEV(clse),4)
,ROUND(AVG(clse),4)
,ROUND(MAX(clse),4)
FROM di5min
WHERE ydate > sysdate - 0.5
GROUP BY pair
ORDER BY pair
/
