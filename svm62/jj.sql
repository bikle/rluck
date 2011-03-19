SELECT
pair
,ydate
FROM ibf5min
WHERE TRUNC(ydate)='2011-03-06'
ORDER BY pair,ydate
/

SELECT
pair
,ydate
FROM ibf5min
WHERE TRUNC(ydate)='2011-03-13'
ORDER BY pair,ydate
/
exit
