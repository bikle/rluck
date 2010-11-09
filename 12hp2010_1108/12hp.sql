--
-- 12hp.sql
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
-- Get ydate 12 hours in the future:
,LEAD(ydate,12,NULL)OVER(PARTITION BY pair ORDER BY pair,ydate) ydate12
-- Get closing price 12 hours in the future:
,LEAD(clse,11,NULL)OVER(PARTITION BY pair ORDER BY pair,ydate) clse12
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
,ydate12
,clse12
,(clse12 - opn)/opn npg
FROM hp10
ORDER BY pair,ydate
/

--rpt
SELECT COUNT(ydate)FROM hp10;
SELECT AVG(ydate12 - ydate), MIN(ydate12 - ydate),MAX(ydate12 - ydate),COUNT(ydate)FROM hp12;
-- I should see no rows WHERE the date difference is less than 12 hours:
SELECT COUNT(ydate)FROM hp12 WHERE (ydate12 - ydate) < 0.5;


-- I should see some rows 
-- WHERE the date difference is greater than 12 hours due to Saturday getting sandwiched between some of the records.
-- Also if I am missing some rows, that will show up here:
SELECT TO_CHAR(ydate,'Day'),MIN(ydate),COUNT(ydate),MAX(ydate)
FROM hp12 WHERE (ydate12 - ydate) > 0.5
GROUP BY TO_CHAR(ydate,'Day')
ORDER BY COUNT(ydate)
/

exit


-- For each pair, look at dow WHERE ydate > '2009-01-01'
CREATE OR REPLACE VIEW h12hpx AS
SELECT pair,dhr
,ROUND(AVG(nhgain),5)   avg_nhgain
,ROUND(SUM(nhgain),4)   sum_nhgain
,COUNT(nhgain)          count_nhgain
,ROUND(STDDEV(nhgain),4)stddev_nhgain
FROM
(
  SELECT
  pair
  -- ydate is granular down to the hour:
  ,ydate
  ,opn
  ,clse
  -- Hourly gain:
  ,(clse-opn)      hgain
  -- Normalized hourly gain:
  ,(clse-opn)/opn nhgain
  ,TO_CHAR(ydate,'D')||'_'||TO_CHAR(ydate,'HH24')dhr
  -- Guard against divide by zero:
  FROM hourly WHERE opn>0
)
WHERE ydate > '2009-01-01'
GROUP BY pair,dhr
-- I want more than 1/2 pip / hour:
HAVING ABS(AVG(nhgain)) > 0.0001 / 2
-- I sort largest gainers to the top:
ORDER BY ABS(AVG(nhgain))DESC


-- I show it:
SELECT count(*) FROM h12hp;

exit
