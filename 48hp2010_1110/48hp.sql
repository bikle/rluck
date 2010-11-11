--
-- 48hp.sql
--

SET LINES 66
DESC hourly
SET LINES 166

-- What is the duration of hourly?:
SELECT
TO_CHAR(ydate,'YYYY')yr
,MIN(ydate)
,COUNT(ydate)
,MAX(ydate)
FROM hourly
GROUP BY TO_CHAR(ydate,'YYYY')
ORDER BY TO_CHAR(ydate,'YYYY')
/

-- What is the distribution of pairs for after 2009-01-01?:
SELECT
TO_CHAR(ydate,'YYYY')yr
,pair
,MIN(ydate)
,COUNT(ydate)
,MAX(ydate)
FROM hourly
WHERE ydate>'2009-01-01'
GROUP BY TO_CHAR(ydate,'YYYY'),pair
ORDER BY TO_CHAR(ydate,'YYYY'),pair
/

CREATE OR REPLACE VIEW hp1048 AS
SELECT
pair
-- ydate is granular down to the hour:
,ydate
,opn
-- Derive an attribute I call "day_hour":
,TO_CHAR(ydate,'D')||'_'||TO_CHAR(ydate,'HH24')dhr
-- Get ydate 48 hours in the future:
,LEAD(ydate,48,NULL)OVER(PARTITION BY pair ORDER BY pair,ydate) ydate48
-- Get closing price 48 hours in the future:
,LEAD(clse,47,NULL)OVER(PARTITION BY pair ORDER BY pair,ydate) clse48
FROM hourly 
WHERE ydate > '2009-01-01'
-- Prevent divide by zero:
AND opn > 0
ORDER BY pair,ydate
/

-- I derive more attributes:
CREATE OR REPLACE VIEW hp48 AS
SELECT
pair
,ydate
,opn
,dhr
,ydate48
,clse48
,(clse48 - opn)/opn npg
FROM hp1048
ORDER BY pair,ydate
/

-- Now I can aggregate:
SELECT
pair,dhr
,COUNT(npg)          count_npg
,ROUND(MIN(npg),4)   min_npg
,ROUND(AVG(npg),4)   avg_npg
,ROUND(STDDEV(npg),4)stddev_npg
,ROUND(MAX(npg),4)   max_npg
,ROUND(SUM(npg),4)   sum_npg
FROM hp48
-- I want my holding to span Sat,Sun if nec:
WHERE (ydate48 - ydate) <= 4.0
GROUP BY pair,dhr
-- I want more than 0.5 pip / hr 
HAVING ABS(AVG(npg)) > 0.5*0.0001*48
ORDER BY pair,dhr
/

exit

