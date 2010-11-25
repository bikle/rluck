-- 
-- 4hp.sql
--

SET LINES 66
-- I create h15c using h15c.sql to derive prices from hourly table:
DESC h15c
SET LINES 166

CREATE OR REPLACE VIEW hp410 AS
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
-- Calculate "Normalized-Price-Gain":
,((LEAD(clse,4,NULL)OVER(PARTITION BY pair ORDER BY pair,ydate) - clse)/clse) npg
FROM h15c
WHERE ydate >= '2007-07-01'
-- Prevent divide by zero:
AND clse > 0
ORDER BY pair,ydate
/

-- hp410 rpt:
-- I should see 15 pairs and nearly identical counts for each pair:
SELECT pair,MIN(ydate),COUNT(*),MAX(ydate)FROM hp410 GROUP BY pair ORDER BY pair;

-- Study distribution of (ydate4 - ydate):
SELECT AVG(ydate4 - ydate), MIN(ydate4 - ydate),MAX(ydate4 - ydate),COUNT(ydate)FROM hp410;

-- I should see no rows WHERE the date difference is less than 4 hours:
SELECT COUNT(ydate)FROM hp410 WHERE (ydate4 - ydate) < 4/24;

-- I should see many rows WHERE the date difference is exactly 4 hours:
SELECT COUNT(ydate)FROM hp410 WHERE (ydate4 - ydate) = 4/24;

-- I should see some rows 
-- WHERE the date difference is greater than 4 hours due to Saturday getting sandwiched between some of the records.
-- Also if I am missing some rows, counts will appear here:
SELECT TO_CHAR(ydate,'Day'),MIN(ydate),COUNT(ydate),MAX(ydate)
FROM hp410 WHERE (ydate4 - ydate) > 4/24
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
FROM hp410
GROUP BY pair,dhr
/

-- I want more than 2 pips / hr:
SELECT * FROM hp4agg WHERE ABS(avg_npg) > 2 * 0.0001 * 4 ORDER BY dhr,pair;

SELECT dhr,ROUND(SUM(ABS(sum_npg)),4)SUM_npg FROM 
  (SELECT * FROM hp4agg WHERE ABS(avg_npg) > 2 * 0.0001 * 4)
GROUP BY dhr ORDER BY dhr
/

-- I want to see 2010:
CREATE OR REPLACE VIEW hp4agg2010 AS
SELECT
pair,dhr
,COUNT(npg)count_npg
,ROUND(MIN(npg),4)min_npg
,ROUND(AVG(npg),4)avg_npg
,ROUND(STDDEV(npg),4)stddev_npg
,ROUND(MAX(npg),4)max_npg
,ROUND(SUM(npg),4)sum_npg
FROM hp410
WHERE ydate > '2010-01-01'
GROUP BY pair,dhr
/

-- I want more than 2 pips / hr:
SELECT * FROM hp4agg2010 WHERE ABS(avg_npg) > 2 * 0.0001 * 4 ORDER BY dhr,pair;

SELECT dhr,ROUND(SUM(ABS(sum_npg)),4)SUM_npg FROM 
  (SELECT * FROM hp4agg2010 WHERE ABS(avg_npg) > 2 * 0.0001 * 4)
GROUP BY dhr ORDER BY dhr
/

exit



