--
-- cr_dom.sql
--

-- I use this script to create a table which joins each row from fxw with another row in fxw which is 1 day ahead.
-- Also I derive some data like the number of the quarter which the day is in and the daily gain for each day.

DROP TABLE dom;
CREATE TABLE dom COMPRESS AS
SELECT
a.pair
,a.ydate ydate1
,a.clse  clse1
,b.ydate ydate2
,b.clse  clse2
-- dgain is daily gain
,b.clse - a.clse dgain
-- ndgain is normalized daily gain (useful for dealing with jpy):
,(b.clse - a.clse)/a.clse ndgain
,0+TO_CHAR(a.ydate,'DD')day_of_month
,0+TO_CHAR(a.ydate,'DD')dom
,0+TO_CHAR(a.ydate,'YYYY')yr
FROM fxw a, fxw b
WHERE a.pair = b.pair
AND b.ydate - a.ydate = 1
-- Protect from divide by zero:
AND a.clse > 0
AND a.ydate >= '2007-01-01'
/

-- rpt
SELECT yr,COUNT(*)FROM dom GROUP BY yr ORDER BY yr ;

exit

