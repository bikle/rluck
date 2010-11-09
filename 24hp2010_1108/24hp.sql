--
-- 24hp.sql
--

SET LINES 66
DESC hourly
SET LINES 166

CREATE OR REPLACE VIEW hp10 AS
SELECT
pair
-- ydate is granular down to the hour:
,ydate
,opn
-- Derive an attribute I call "day_hour":
,TO_CHAR(ydate,'D')||'_'||TO_CHAR(ydate,'HH24')dhr
-- Get ydate 24 hours in the future:
,LEAD(ydate,24,NULL)OVER(PARTITION BY pair ORDER BY pair,ydate) ydate24
-- Get closing price 24 hours in the future:
,LEAD(clse,11,NULL)OVER(PARTITION BY pair ORDER BY pair,ydate) clse24
FROM hourly 
WHERE ydate > '2009-01-01'
-- Prevent divide by zero:
AND opn > 0
ORDER BY pair,ydate
/

-- I derive more attributes:
CREATE OR REPLACE VIEW hp24 AS
SELECT
pair
,ydate
,opn
,dhr
,ydate24
,clse24
,(clse24 - opn)/opn npg
FROM hp10
ORDER BY pair,ydate
/

--rpt
SELECT COUNT(ydate)FROM hp10;
SELECT AVG(ydate24 - ydate), MIN(ydate24 - ydate),MAX(ydate24 - ydate),COUNT(ydate)FROM hp24;
-- I should see no rows WHERE the date difference is less than 24 hours:
SELECT COUNT(ydate)FROM hp24 WHERE (ydate24 - ydate) < 0.5;

-- I should see many rows WHERE the date difference is exactly 24 hours:
SELECT COUNT(ydate)FROM hp24 WHERE (ydate24 - ydate) = 1;

-- I should see some rows 
-- WHERE the date difference is greater than 24 hours due to Saturday getting sandwiched between some of the records.
-- Also if I am missing some rows, counts will appear here:
SELECT TO_CHAR(ydate,'Day'),MIN(ydate),COUNT(ydate),MAX(ydate)
FROM hp24 WHERE (ydate24 - ydate) > 0.5
GROUP BY TO_CHAR(ydate,'Day')
ORDER BY COUNT(ydate)
/

-- Now I can aggregate:
CREATE OR REPLACE VIEW hdp AS
SELECT
pair
,ydate
,opn
,dhr
,ydate24
,clse24
,npg
FROM hp24
WHERE (ydate24 - ydate) = 0.5
/

-- The query below gives me an idea of the scale of each aggregation:
SELECT
dhr
,COUNT(npg)count_npg
,ROUND(SUM(npg),4)sum_npg
,ROUND(MIN(npg),4)min_npg
,ROUND(AVG(npg),4)avg_npg
,ROUND(MAX(npg),4)max_npg
,ROUND(STDDEV(npg),4)stddev_npg
FROM hdp
GROUP BY dhr
ORDER BY dhr
/

-- The above aggregation is interesting but it shows no pairs.
-- I need to know about pairs:
SELECT
pair,dhr
,COUNT(npg)count_npg
,ROUND(MIN(npg),4)min_npg
,ROUND(AVG(npg),4)avg_npg
,ROUND(STDDEV(npg),4)stddev_npg
,ROUND(MAX(npg),4)max_npg
,ROUND(SUM(npg),4)sum_npg
FROM hdp
GROUP BY pair,dhr
-- I want more than 1 pip / hr which is 24 pips:
HAVING AVG(npg) > 0.0024
ORDER BY pair,dhr
/


exit

