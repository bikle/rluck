--
-- qry_aud_usd_wk10.sql
--

-- This shows results for going-long on aud_usd during week 10 of quarter and holding for 1 day.

SELECT
pair
,ydate1
-- Normalized daily gain:
,ROUND(ndgain,4)n_daily_gain
,yr
,woq
FROM djd12
WHERE pair = 'aud_usd'
AND ydate1 > '2009-01-01'
AND woq = 10
ORDER BY ydate1
/

exit
