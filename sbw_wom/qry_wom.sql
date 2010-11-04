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
CREATE OR REPLACE VIEW wjw2007 AS SELECT pair,wom,qtr,AVG(nwgain)avgg FROM wjw WHERE yr = '2007'GROUP BY pair,wom,qtr;

CREATE OR REPLACE VIEW wjww0 AS
SELECT
a.pair
,a.wom
,a.qtr
,a.avgg avg07
,b.avgg avg08
,b.avgg avg09
,b.avgg avg10
FROM wjw2007 a, wjw2008 b, wjw2009 c, wjw2010 d
WHERE a.pair = b.pair AND a.wom = b.wom AND a.qtr = b.qtr
AND   a.pair = c.pair AND a.wom = c.wom AND a.qtr = c.qtr
AND   a.pair = d.pair AND a.wom = d.wom AND a.qtr = d.qtr
ORDER BY a.pair,a.wom,a.qtr
/

SELECT COUNT(*) FROM wjww0 WHERE ABS(SIGN(avg07)+SIGN(avg07)+SIGN(avg07)+SIGN(avg10)) = 4;

SELECT * FROM wjww0;
SELECT * FROM wjww0 WHERE ABS(SIGN(avg07)+SIGN(avg07)+SIGN(avg07)+SIGN(avg10)) = 4;

CREATE OR REPLACE VIEW wjww1 AS
SELECT
pair
,wom
,qtr
,avg07
,avg08
,avg09
,avg10
,COUNT(pair||wom)OVER(PARTITION BY pair,wom ORDER BY pair,wom,qtr)
FROM wjww0
/

exit



