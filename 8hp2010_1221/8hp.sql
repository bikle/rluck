--
-- 8hp.sql
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
-- Get ydate 8 hours in the future:
,LEAD(ydate,8,NULL)OVER(PARTITION BY pair ORDER BY pair,ydate) ydate8
-- Get closing price 8 hours in the future:
,LEAD(clse,5,NULL)OVER(PARTITION BY pair ORDER BY pair,ydate) clse8
FROM hourly 
WHERE ydate > '2009-01-01'
-- Prevent divide by zero:
AND opn > 0
ORDER BY pair,ydate
/

-- I derive more attributes:
CREATE OR REPLACE VIEW hp12 AS
SELECT
pair
,ydate
,opn
,dhr
,ydate8
,clse8
,(clse8 - opn)/opn npg
FROM hp10
ORDER BY pair,ydate
/

--rpt
SELECT 
pair
,MIN(ydate)
,COUNT(ydate)
,MAX(ydate)
FROM hp10
GROUP BY pair
ORDER BY pair
/

SELECT AVG(ydate8 - ydate), MIN(ydate8 - ydate),MAX(ydate8 - ydate),COUNT(ydate)FROM hp12;
-- I should see no rows WHERE the date difference is less than 8 hours:
SELECT COUNT(ydate)FROM hp12 WHERE (ydate8 - ydate) < 8/24;

-- I should see many rows WHERE the date difference is exactly 8 hours:
SELECT COUNT(ydate)FROM hp12 WHERE (ydate8 - ydate) = 8/24;

-- I should see some rows 
-- WHERE the date difference is greater than 8 hours due to Saturday getting sandwiched between some of the records.
-- Also if I am missing some rows, counts will appear here:
SELECT TO_CHAR(ydate,'Day'),MIN(ydate),COUNT(ydate),MAX(ydate)
FROM hp12 WHERE (ydate8 - ydate) > 8/24
GROUP BY TO_CHAR(ydate,'Day')
ORDER BY COUNT(ydate)
/

-- Now I can aggregate:
SELECT
pair,dhr
,COUNT(npg)count_npg
,ROUND(MIN(npg),4)min_npg
,ROUND(AVG(npg),4)avg_npg
,ROUND(STDDEV(npg),4)stddev_npg
,ROUND(MAX(npg),4)max_npg
,ROUND(SUM(npg),4)sum_npg
FROM hp12
WHERE (ydate8 - ydate) = 8/24
GROUP BY pair,dhr
-- I want more than 1.0 pip / hr which is 8 pips:
HAVING ABS(AVG(npg)) > 0.0008
ORDER BY dhr,pair
/


exit

