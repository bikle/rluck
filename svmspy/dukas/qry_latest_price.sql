--
-- qry_latest_price.sql
--

-- I use this script to look at the latest price of each tkr in the dukas10min_stk table.

SELECT
tkr
,clse
FROM dukas10min_stk
WHERE ydate IN (SELECT MAX(ydate)FROM dukas10min_stk)
ORDER BY tkr
/
