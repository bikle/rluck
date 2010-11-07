--
-- bb_wom.sql
--

SET LINES 66
DESC hourly
SET LINES 166

-- For each pair, look at wom WHERE ydate > '2009-01-01'
-- Filter out anything with abs(nhgain) < 0.0001 / 4
CREATE OR REPLACE VIEW bb_wom AS
SELECT
pair,week_of_month
,ROUND(avg_nhgain,6)avg_nhgain
,ROUND(sum_nhgain,4)sum_nhgain
,count_nhgain
FROM
(  
  SELECT 
  pair,week_of_month
  ,AVG(nhgain)  avg_nhgain
  ,SUM(nhgain)  sum_nhgain
  ,COUNT(nhgain)count_nhgain
  FROM
  (
    SELECT
    pair
    ,ydate
    ,opn
    ,clse
    -- Hourly gain:
    ,(clse-opn)     hgain
    -- Normalized hourly gain:
    ,(clse-opn)/opn nhgain
    ,0+TO_CHAR(ydate,'W')week_of_month
    FROM hourly WHERE opn>0
  )
  WHERE ydate > '2009-01-01'
  GROUP BY pair,week_of_month
)
-- I only want to see trades which give more that 1/4 pip per hour:
WHERE ABS(avg_nhgain) > (0.0001 / 4)
/

-- I want to see USD bearish positions first.
SELECT * FROM bb_wom
WHERE 
(
  (pair LIKE'%_usd'AND avg_nhgain>0)
  OR
  (pair LIKE'usd_%'AND avg_nhgain<0)
)
-- Sort better trades to the top:
ORDER BY ABS(avg_nhgain) DESC
/


-- Now show USD bullish positions:
SELECT * FROM bb_wom
WHERE 
(
  (pair LIKE'%_usd'AND avg_nhgain<0)
  OR
  (pair LIKE'usd_%'AND avg_nhgain>0)
)
-- Sort better trades to the top:
ORDER BY ABS(avg_nhgain) DESC
/

exit
