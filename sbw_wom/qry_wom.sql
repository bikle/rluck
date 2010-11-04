--
-- qry_wom.sql
--

-- I want to see my data 1st:
SELECT
yr
,pair
,wom
,AVG(nwgain)
,SUM(nwgain)
FROM wjw
WHERE yr = '2010'
GROUP BY yr,pair,wom
ORDER BY yr,pair,wom
/

-- ok now work with it:
CREATE OR REPLACE VIEW wjw2010 AS SELECT pair,wom,AVG(nwgain)avgg FROM wjw WHERE yr = '2010'GROUP BY pair,wom;
CREATE OR REPLACE VIEW wjw2009 AS SELECT pair,wom,AVG(nwgain)avgg FROM wjw WHERE yr = '2009'GROUP BY pair,wom;
CREATE OR REPLACE VIEW wjw2008 AS SELECT pair,wom,AVG(nwgain)avgg FROM wjw WHERE yr = '2008'GROUP BY pair,wom;
CREATE OR REPLACE VIEW wjw2007 AS SELECT pair,wom,AVG(nwgain)avgg FROM wjw WHERE yr = '2007'GROUP BY pair,wom;

CREATE OR REPLACE VIEW wjw0910 AS
SELECT
a.pair
,a.wom
,a.avgg avgga
,b.avgg avggb
FROM wjw2009 a, wjw2010 b
WHERE a.pair = b.pair AND a.wom = b.wom
/

SELECT
pair
,wom
,avgga
,avggb
,avgga * avggb ab_prod
FROM wjw0910
WHERE (avgga * avggb) > 0
ORDER BY (avgga * avggb) DESC
/

exit



