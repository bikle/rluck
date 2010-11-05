--
-- sbw_wom.sql
--

SET LINES 66
DESC hourly
SET LINES 166

-- For each pair, look at wom over 2009, 2010:
SELECT pair,week_of_month,AVG(nhgain),SUM(nhgain),COUNT(nhgain)
FROM
(
  SELECT
  pair
  ,ydate
  ,opn
  ,clse
  -- Hourly gain:
  ,(clse-opn)      hgain
  -- Normalized hourly gain:
  ,(clse-opn)/opn nhgain
  ,0+TO_CHAR(ydate,'W')week_of_month
  FROM hourly WHERE opn>0
)
WHERE ydate > '2009-01-01'
GROUP BY pair,week_of_month
ORDER BY ABS(AVG(nhgain))DESC
/

exit
