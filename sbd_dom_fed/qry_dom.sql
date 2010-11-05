--
-- qry_dom.sql
--

-- This helps me search for correlation trends related to "Day of Month".

SELECT
pair
,day_of_month
,AVG(ndgain)avg_ndg
,SUM(ndgain)sum_ndg
,COUNT(ndgain)ccount
FROM dom
GROUP BY pair,day_of_month
HAVING ABS(AVG(ndgain)) > 0.0023
ORDER BY ABS(AVG(ndgain))DESC
/

exit
