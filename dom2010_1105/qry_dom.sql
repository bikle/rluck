--
-- qry_dom.sql
--

-- This helps me search for correlation trends related to "Day of Month".

-- First, I get a quick scan of the data I have:
SELECT yr,COUNT(yr)FROM dom GROUP BY yr ORDER BY yr ;
SELECT pair,COUNT(pair)FROM dom GROUP BY pair ORDER BY pair ;
SELECT day_of_month,COUNT(day_of_month)FROM dom GROUP BY day_of_month ORDER BY day_of_month ;

-- Now start a serious look for a Correlation Trend by a simple aggregation over all years in the dom table.
-- I want a return of 1 pip / hr so I filter out anything less than that:

CREATE OR REPLACE VIEW dom78910 AS
SELECT
pair
,day_of_month
,AVG(ndgain)avg_ndg
,SUM(ndgain)sum_ndg
,MIN(ydate1)mn_date
,COUNT(ndgain)ccount
,MAX(ydate2)mx_date
FROM dom
GROUP BY pair,day_of_month
HAVING ABS(AVG(ndgain)) > 0.0024
ORDER BY ABS(AVG(ndgain))DESC
/

SELECT * FROM dom78910;

-- Now look for declines of USD value:
SELECT pair,day_of_month,avg_ndg FROM dom78910
WHERE (pair LIKE'%_usd'AND avg_ndg>0)
OR    (pair LIKE'usd_%'AND avg_ndg<0)
/

-- Perhaps it is weighted near the end of the month.
-- Try a simple avg:
SELECT AVG(day_of_month)FROM dom78910
WHERE (pair LIKE'%_usd'AND avg_ndg>0)
OR    (pair LIKE'usd_%'AND avg_ndg<0)
/

-- Now look for increases of USD value:
SELECT pair,day_of_month,avg_ndg FROM dom78910
WHERE (pair LIKE'%_usd'AND avg_ndg<0)
OR    (pair LIKE'usd_%'AND avg_ndg>0)
/

-- Perhaps it is weighted near the start of the month.
-- Try a simple avg:
SELECT AVG(day_of_month)FROM dom78910
WHERE (pair LIKE'%_usd'AND avg_ndg<0)
OR    (pair LIKE'usd_%'AND avg_ndg>0)
/

-- Do it all over again but only for 2009, 2010:

CREATE OR REPLACE VIEW dom910 AS
SELECT
pair
,day_of_month
,AVG(ndgain)avg_ndg
,SUM(ndgain)sum_ndg
,MIN(ydate1)mn_date
,COUNT(ndgain)ccount
,MAX(ydate2)mx_date
FROM dom
WHERE ydate1 BETWEEN'2009-01-01'AND'2010-12-31'
GROUP BY pair,day_of_month
HAVING ABS(AVG(ndgain)) > 0.0024
ORDER BY ABS(AVG(ndgain))DESC
/

SELECT * FROM dom910;

-- Now look for declines of USD value:
SELECT pair,day_of_month,avg_ndg FROM dom910
WHERE (pair LIKE'%_usd'AND avg_ndg>0)
OR    (pair LIKE'usd_%'AND avg_ndg<0)
/

-- Perhaps it is weighted near the end of the month.
-- Try a simple avg:
SELECT AVG(day_of_month)FROM dom910
WHERE (pair LIKE'%_usd'AND avg_ndg>0)
OR    (pair LIKE'usd_%'AND avg_ndg<0)
/

-- Now look for increases of USD value:
SELECT pair,day_of_month,avg_ndg FROM dom910
WHERE (pair LIKE'%_usd'AND avg_ndg<0)
OR    (pair LIKE'usd_%'AND avg_ndg>0)
/

-- Perhaps it is weighted near the start of the month.
-- Try a simple avg:
SELECT AVG(day_of_month)FROM dom910
WHERE (pair LIKE'%_usd'AND avg_ndg<0)
OR    (pair LIKE'usd_%'AND avg_ndg>0)
/

-- For years 2008, 2009, 2010 look for a Correlation Trend for a pair-dom combo:

CREATE OR REPLACE VIEW dom8  AS SELECT pair,dom,AVG(ndgain)avg8  FROM dom WHERE yr=2008 GROUP BY pair,dom;
CREATE OR REPLACE VIEW dom9  AS SELECT pair,dom,AVG(ndgain)avg9  FROM dom WHERE yr=2009 GROUP BY pair,dom;
CREATE OR REPLACE VIEW dom10 AS SELECT pair,dom,AVG(ndgain)avg10 FROM dom WHERE yr=2010 GROUP BY pair,dom;

CREATE OR REPLACE VIEW dom8910 AS
SELECT a.pair,a.dom,avg8,avg9,avg10
FROM dom8 a, dom9 b, dom10 c
WHERE a.pair = b.pair AND a.dom = b.dom
AND   a.pair = c.pair AND a.dom = c.dom
/

-- See it:
SELECT * FROM dom8910
-- I want all the avgs to be the same sign:
WHERE ABS(SIGN(avg8)+SIGN(avg9)+SIGN(avg10))=3
-- I want more than 1 pip / hour:
AND ABS(avg8 + avg9 + avg10) > (3 * 24 * 0.0001)
-- Sort by avg giving more weight to more recent data:
ORDER BY ABS(1*avg8 + 2*avg9 + 3*avg10) DESC
/

exit


