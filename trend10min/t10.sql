--
-- t10.sql
--

-- I use this script to look at Forex data which has a 10 minute duration between each datapoint.

SET LINES 66
DESC dukas10min
SET LINES 166

SELECT
pair
,MIN(ydate)
,COUNT(*)
,MAX(ydate)
FROM dukas10min
GROUP BY pair
ORDER BY pair
/


CREATE OR REPLACE VIEW tr10 AS
SELECT
pair
-- ydate is granular down to 10 min:
,ydate
,clse
-- Use analytic function to get moving average1:
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 5 PRECEDING AND 1 PRECEDING)ma1_4
-- Use analytic function to get moving average2:
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 4 PRECEDING AND CURRENT ROW)ma2_4
-- Get future ydates
,LEAD(ydate,4,NULL)OVER(PARTITION BY pair ORDER BY ydate) ydate4
-- Relative to current-row, get future closing prices:
,LEAD(clse,4,NULL)OVER(PARTITION BY pair ORDER BY ydate) clse4
FROM dukas10min
-- Prevent divide by zero:
WHERE clse > 0
ORDER BY pair,ydate
/

-- rpt

SELECT
pair
,MIN(ydate4)
,COUNT(*)
,MAX(ydate4)
,MIN(clse4)
,MAX(clse4)
FROM tr10
GROUP BY pair
ORDER BY pair
/


-- I derive "normalized" slope of moving-averages.
-- I normalize them to help me compare JPY pairs to all the other pairs:

CREATE OR REPLACE VIEW tr12 AS
SELECT
pair
,ydate
,clse
,ma1_4
,ma2_4
,ydate4
,clse4
-- Derive normalized mvg-avg-slope:
,(ma2_4 - ma1_4)/ma1_4 ma4_slope
FROM tr10
-- Prevent divide by zero:
WHERE clse > 0
ORDER BY pair,ydate
/

EXIT
