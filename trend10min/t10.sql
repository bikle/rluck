--
-- t10.sql
--

-- I use this script to look at Forex data which has a 10 minute duration between each datapoint.

SET LINES 66
DESC dukas10min
SET LINES 166

SELECT
pair
,MIN(ydate)
,COUNT(*)
,MAX(ydate)
FROM dukas10min
GROUP BY pair
ORDER BY pair
/

EXIT
