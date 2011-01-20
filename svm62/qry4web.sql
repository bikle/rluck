--
-- qry4web.sql
--

-- I use this script to gather data for exposure to the web.

-- Get prices first.
SELECT
pair
,ydate
,clse
FROM di5min
WHERE ydate > sysdate - 0.5/24
ORDER BY pair,ydate
/

exit
