--
-- sbw_woq_h.sql
--

-- For each pair, look at woq WHERE ydate > '2009-01-01'
-- This script is similar to sbw_wom.sql
SELECT
pair
,week_of_qtr
,ROUND(AVG(nhgain),5)avg_n_hgain
,ROUND(SUM(nhgain),4)sum_n_hgain
,COUNT(nhgain)
,ROUND(STDDEV(nhgain),4)stddev_n_hgain
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
WHERE week_of_qtr BETWEEN 1 AND 13
GROUP BY pair,week_of_qtr
-- HAVING COUNT(pair)>200
-- I want more than 1/2 pip per hour:
HAVING ABS(AVG(nhgain)) > (0.0001 / 2)
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
