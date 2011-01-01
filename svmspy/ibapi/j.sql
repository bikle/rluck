CREATE TABLE dropme COMPRESS AS
SELECT
prdate
,pair
,ydate
,clse
FROM
(
  SELECT
  prdate
  ,pair
  ,ydate
  ,AVG(clse)clse
  FROM di5min0
  GROUP BY 
  prdate
  ,pair
  ,ydate
  UNION
  SELECT
  prdate
  ,pair
  ,ydate
  ,clse
  FROM op5min
)
/
