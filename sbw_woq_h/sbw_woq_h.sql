--
-- sbw_woq_h.sql
--

-- For each pair, look at woq WHERE ydate > '2009-01-01'
-- This script is similar to sbw_wom.sql
SELECT pair,week_of_qtr,AVG(nhgain),SUM(nhgain),COUNT(nhgain)
FROM
(
  SELECT
  pair
  ,ydate
  ,nhgain
  -- Step 2 of calculating week_of_qtr:
  ,week_of_year - 13*(qtr-1)week_of_qtr
  FROM
  (
    SELECT
    pair
    ,ydate
    -- Normalized hourly gain:
    ,(clse-opn)/opn nhgain
    -- Step 1 of calculating week_of_qtr:
    ,0+TO_CHAR(ydate,'WW')week_of_year
    ,0+TO_CHAR(ydate,'Q')qtr
    FROM hourly
    -- Guard against divide-by-zero:
    WHERE opn>0
    -- I mistrust the 2008 data quality:
    AND ydate > '2009-01-01'
  )
)
GROUP BY pair,week_of_qtr
HAVING COUNT(pair)>200
ORDER BY ABS(AVG(nhgain))DESC
/

-- What is the week_of_qtr calculation for today?
SELECT 
(week_of_year - 13*(qtr-1))week_of_qtr
,sysdate
FROM
(
  SELECT
  0+TO_CHAR(sysdate,'WW')week_of_year
  ,0+TO_CHAR(sysdate,'Q')qtr 
  FROM dual
)
/

exit
