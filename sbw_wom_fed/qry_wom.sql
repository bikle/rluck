--
-- qry_wom.sql
--

-- I want to see my data 1st:
SELECT
pair
,wom
,yr
,qtr
,AVG(nwgain)
,SUM(nwgain)
FROM wjw
WHERE yr = '2010'
GROUP BY pair,wom,yr,qtr
ORDER BY pair,wom,yr,qtr
/

-- ok now work with it:
CREATE OR REPLACE VIEW wjw2010 AS SELECT pair,wom,qtr,AVG(nwgain)avgg FROM wjw WHERE yr = '2010'GROUP BY pair,wom,qtr;
CREATE OR REPLACE VIEW wjw2009 AS SELECT pair,wom,qtr,AVG(nwgain)avgg FROM wjw WHERE yr = '2009'GROUP BY pair,wom,qtr;
CREATE OR REPLACE VIEW wjw2008 AS SELECT pair,wom,qtr,AVG(nwgain)avgg FROM wjw WHERE yr = '2008'GROUP BY pair,wom,qtr;

-- Join all 3 years so I can have the avgs talk to each other:
CREATE OR REPLACE VIEW wjww0 AS
SELECT
a.pair
,a.wom
,a.qtr
,a.avgg avg08
,b.avgg avg09
,c.avgg avg10
FROM wjw2008 a, wjw2009 b, wjw2010 c
WHERE a.pair = b.pair AND a.wom = b.wom AND a.qtr = b.qtr
AND   a.pair = c.pair AND a.wom = c.wom AND a.qtr = c.qtr
ORDER BY a.pair,a.wom,a.qtr
/

-- I want to see it first:
SELECT * FROM wjww0;

-- Too much data up there.
-- I want a count of rows where all the avgs are same sign:
SELECT COUNT(*) FROM wjww0 WHERE ABS(SIGN(avg08)+SIGN(avg09)+SIGN(avg10)) = 3;

-- That is not many.  I look at them now:
SELECT * FROM wjww0 WHERE ABS(SIGN(avg08)+SIGN(avg09)+SIGN(avg10)) = 3;


-- I want a list of pairs where wom is the same across as many qtrs as possible.
-- I'll use analytic functions to compare data between rows and aggregate data of related rows:
CREATE OR REPLACE VIEW wjww1 AS
SELECT
pair
,wom
,qtr
,avg08
,avg09
,avg10
,COUNT(pair||wom)     OVER(PARTITION BY pair,wom ORDER BY pair,wom,qtr)ccount
,           LAG(avg10)OVER(PARTITION BY pair,wom ORDER BY pair,wom,qtr)avg10lag
,SIGN(avg10*LAG(avg10)OVER(PARTITION BY pair,wom ORDER BY pair,wom,qtr))lgsign
FROM wjww0
WHERE ABS(SIGN(avg08)+SIGN(avg09)+SIGN(avg10)) = 3
/

-- I look at the data.  It is the same data as the previous query but
-- with 3 additional rows of data derived from analytic functions:

SELECT * FROM wjww1;

-- I want a list of pairs where wom is the same across as many qtrs as possible.
-- Also I want the avg-gain to be the same sign across all the wom:
SELECT * FROM wjww1 WHERE lgsign=1;

-- That is not much data.  I use wjw to drill down into it:
SELECT COUNT(*)FROM wjw WHERE pair='usd_chf'AND wom=5 AND 0+yr IN(2008,2009,2010)AND qtr IN(2,3);

-- I see a mix of negative and positive gains below.
-- I'd prefer they all be the same sign:
SELECT
ydate1
,ydate2
,clse1
,clse2
,wgain
FROM wjw
WHERE pair='usd_chf'AND wom=5 AND 0+yr IN(2008,2009,2010)AND qtr IN(1,2)
ORDER BY ydate1
/

exit
