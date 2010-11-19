--
-- 4hp.sql
--

SET LINES 66
DESC hourly
SET LINES 166

CREATE OR REPLACE VIEW hp10 AS
SELECT
pair
-- ydate is granular down to the hour:
,ydate
,clse
-- Derive an attribute I call "day_hour":
,TO_CHAR(ydate,'D')||'_'||TO_CHAR(ydate,'HH24')dhr
-- Get ydate 4 hours in the future:
,LEAD(ydate,4,NULL)OVER(PARTITION BY pair ORDER BY pair,ydate) ydate4
-- Get closing price 4 hours in the future:
,LEAD(clse,4,NULL)OVER(PARTITION BY pair ORDER BY pair,ydate) clse4
FROM hourly 
WHERE ydate > '2009-01-01'
-- Prevent divide by zero:
AND clse > 0
ORDER BY pair,ydate
/

CREATE OR REPLACE VIEW hp102 AS SELECT * FROM hp10 WHERE ydate > sysdate - 60;

-- I derive more attributes:
CREATE OR REPLACE VIEW hp12 AS
SELECT
pair
,ydate
,clse
,dhr
,ydate4
,clse4
,(clse4 - clse)/clse npg
FROM hp10
ORDER BY pair,ydate
/

CREATE OR REPLACE VIEW hp122 AS SELECT * FROM hp12 WHERE ydate > sysdate - 60;


--rpt
SELECT COUNT(ydate)FROM hp10;
SELECT AVG(ydate4 - ydate), MIN(ydate4 - ydate),MAX(ydate4 - ydate),COUNT(ydate)FROM hp12;
-- I should see no rows WHERE the date difference is less than 4 hours:
SELECT COUNT(ydate)FROM hp12 WHERE (ydate4 - ydate) < 4/24;

-- I should see many rows WHERE the date difference is exactly 4 hours:
SELECT COUNT(ydate)FROM hp12 WHERE (ydate4 - ydate) = 4/24

-- I should see some rows 
-- WHERE the date difference is greater than 4 hours due to Saturday getting sandwiched between some of the records.
-- Also if I am missing some rows, counts will appear here:
SELECT TO_CHAR(ydate,'Day'),MIN(ydate),COUNT(ydate),MAX(ydate)
FROM hp12 WHERE (ydate4 - ydate) > 4/24
GROUP BY TO_CHAR(ydate,'Day')
ORDER BY COUNT(ydate)
/

-- Now I can aggregate:
CREATE OR REPLACE VIEW hp4agg AS
SELECT
pair,dhr
,COUNT(npg)count_npg
,ROUND(MIN(npg),4)min_npg
,ROUND(AVG(npg),4)avg_npg
,ROUND(STDDEV(npg),4)stddev_npg
,ROUND(MAX(npg),4)max_npg
,ROUND(SUM(npg),4)sum_npg
FROM hp12
WHERE (ydate4 - ydate) = 4/24
GROUP BY pair,dhr
-- I want more than 1.5 pip / hr over the 4hr period:
HAVING ABS(AVG(npg)) > 1.5 * 0.0001 * 4
/

-- Sort by pair 1st:
SELECT * FROM hp4agg ORDER BY pair,dhr;

-- Look at last 60 days:

CREATE OR REPLACE VIEW hp4agg2 AS
SELECT
pair,dhr
,COUNT(npg)count_npg
,ROUND(MIN(npg),4)min_npg
,ROUND(AVG(npg),4)avg_npg
,ROUND(STDDEV(npg),4)stddev_npg
,ROUND(MAX(npg),4)max_npg
,ROUND(SUM(npg),4)sum_npg
FROM hp122
WHERE (ydate4 - ydate) = 4/24
GROUP BY pair,dhr
/

SELECT COUNT(*)FROM hp4agg2;

SELECT * FROM hp4agg2 ORDER BY pair,dhr

-- Join agg views:

CREATE OR REPLACE VIEW hp4aggj AS
SELECT
a.pair
,a.dhr
,a.avg_npg avg_npg1
,b.avg_npg avg_npg2
FROM hp4agg a, hp4agg2 b
WHERE a.pair = b.pair AND a.dhr = b.dhr
/

-- Sort by dhr since I can then easily compare to my calendar:
SELECT * FROM hp4aggj ORDER BY dhr,pair;

-- Look for CORR():
SELECT pair, CORR(avg_npg1,avg_npg2),COUNT(*)FROM hp4aggj GROUP BY pair ORDER BY pair;

exit

