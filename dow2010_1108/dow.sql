--
-- dow.sql
--

SET LINES 66
DESC hourly
SET LINES 166

-- For each pair, look at dow WHERE ydate > '2009-01-01'
CREATE OR REPLACE VIEW hdow AS
SELECT pair,day_of_week
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
  ,0+TO_CHAR(ydate,'D')day_of_week
  -- Guard against divide by zero:
  FROM hourly WHERE opn>0
)
WHERE ydate > '2009-01-01'
GROUP BY pair,day_of_week
-- I want more than 1/2 pip / hour:
HAVING ABS(AVG(nhgain)) > 0.0001 / 2
-- I sort largest gainers to the top:
ORDER BY ABS(AVG(nhgain))DESC
/

-- I show it:
SELECT * FROM hdow;

exit
