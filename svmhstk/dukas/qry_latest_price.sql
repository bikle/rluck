--
-- qry_latest_price.sql
--

-- I use this script to look at the latest price of each tkr in the dukas1hr_stk table.

SELECT
tkr
,clse
FROM dukas1hr_stk
WHERE ydate IN (SELECT MAX(ydate)FROM dukas1hr_stk)
ORDER BY tkr
/

SELECT
tkr
,MIN(ydate)
,COUNT(ydate)
,MAX(ydate)
FROM dukas1hr_stk
GROUP BY tkr
ORDER BY tkr
/
