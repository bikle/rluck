--
-- dom.sql
--

SET LINES 66
DESC hourly
SET LINES 166

-- For each pair, look at dom WHERE ydate > '2009-01-01'
CREATE OR REPLACE VIEW hdom AS
SELECT pair,day_of_month
,AVG(nhgain)   avg_nhgain
,SUM(nhgain)   sum_nhgain
,COUNT(nhgain) count_nhgain
,STDDEV(nhgain)stddev_nhgain
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
  ,0+TO_CHAR(ydate,'DD')day_of_month
  -- Guard against divide by zero:
  FROM hourly WHERE opn>0
)
WHERE ydate > '2009-01-01'
GROUP BY pair,day_of_month
-- I want more than 1 pip / hour:
HAVING ABS(AVG(nhgain)) > 0.0001
-- I sort largest gainers to the top:
ORDER BY ABS(AVG(nhgain))DESC
/

-- I show it:
SELECT * FROM hdom;

-- Now I separate USD bears from USD bulls.

-- I show USD bears first:
SELECT * FROM hdom
WHERE 
(
  (pair LIKE'%_usd'AND avg_nhgain>0)
  OR
  (pair LIKE'usd_%'AND avg_nhgain<0)
)
/

-- I show USD bulls next:
SELECT * FROM hdom
WHERE 
(
  (pair LIKE'%_usd'AND avg_nhgain<0)
  OR
  (pair LIKE'usd_%'AND avg_nhgain>0)
)
/

exit
