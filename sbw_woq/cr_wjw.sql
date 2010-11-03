--
-- cr_wjw.sql
--

-- I use this script to create a table which joins each row from fxw with another row in fxw which is 1 week ahead.
-- Also I derive some data like the number of the quarter which the week is in and the weekly gain for each week.

CREATE OR REPLACE VIEW wjw10 AS
SELECT
a.pair
,a.ydate ydate1
,a.clse  clse1
,b.ydate ydate2
,b.clse  clse2
-- wgain is weekly gain
,b.clse - a.clse wgain
,TO_CHAR(a.ydate,'D')day_of_week
,TO_CHAR(a.ydate,'Q')qtr
,TO_CHAR(a.ydate,'YYYY')yr
,TO_CHAR(a.ydate,'WW')week_of_year
FROM fxw a, fxw b
WHERE a.pair = b.pair
AND b.ydate - a.ydate = 7
/

-- rpt
SELECT
ydate1
,clse1
,ydate2
,clse2
FROM wjw10
WHERE pair = 'eur_usd'
AND ydate1 BETWEEN'2010-10-01'AND'2010-11-01'
/


CREATE OR REPLACE VIEW wjw12 AS
SELECT
pair
,ydate1
,clse1
,ydate2
,clse2
,wgain
,day_of_week
,qtr
,yr
,week_of_year
,week_of_year woy
,week_of_year - 13*(qtr-1)woq
,week_of_year - 13*(qtr-1)week_of_qtr
FROM wjw10
/

-- rpt
SELECT
pair
,ydate1
,day_of_week
,wgain
,woq
FROM wjw12
WHERE pair = 'eur_usd'
AND ydate1 BETWEEN'2010-10-01'AND'2010-11-01'
/

DROP TABLE wjw;
CREATE TABLE wjw COMPRESS AS
SELECT
pair
,ydate1
,clse1
,ydate2
,clse2
,wgain
,day_of_week
,qtr
,yr
,week_of_year
,woy
,woq
,week_of_qtr
FROM wjw12
/

ANALYZE TABLE wjw COMPUTE STATISTICS;

-- rpt
SELECT pair,MIN(ydate),COUNT(pair),MAX(ydate)FROM fxw GROUP BY pair ORDER BY pair ;
SELECT pair,MIN(ydate1),COUNT(pair),MAX(ydate2)FROM wjw GROUP BY pair ORDER BY pair ;


exit
