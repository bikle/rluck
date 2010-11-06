--
-- qry_djd.sql
--

-- I use this script to create a table which joins each row from fxw with another row in fxw which is 1 day ahead.
-- Also I derive some data like the number of the quarter which the week is in and the daily gain for each day.


CREATE OR REPLACE VIEW djd10 AS
SELECT
a.pair
,a.ydate ydate1
-- ndgain is normalized daily gain
,(b.clse - a.clse)/a.clse ndgain
,TO_CHAR(a.ydate,'Q')qtr
,TO_CHAR(a.ydate,'YYYY')yr
,TO_CHAR(a.ydate,'WW')week_of_year
FROM fxw a, fxw b
WHERE a.pair = b.pair
AND b.ydate - a.ydate = 1
-- I want to compare this to my hourly data which I have for after 2009-01-01
AND a.ydate > '2009-01-01'
/

-- Derive woq

CREATE OR REPLACE VIEW djd12 AS
SELECT
pair
,ydate1
,ndgain
,yr
,week_of_year - 13*(qtr-1)woq
,week_of_year - 13*(qtr-1)week_of_qtr
FROM djd10
/

-- Now I can aggregate ndgain and GROUP BY week_of_qtr
SELECT
pair,week_of_qtr
,ROUND(AVG(ndgain),4)avg_ndgain
,ROUND(SUM(ndgain),4)sum_ndgain
,COUNT(ndgain)
FROM djd12
WHERE week_of_qtr > 0
GROUP BY pair,week_of_qtr
-- I want more than 12 pips / day
HAVING ABS(AVG(ndgain)) > 0.0012
ORDER BY ABS(AVG(ndgain))DESC
/

exit

