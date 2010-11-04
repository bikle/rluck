
CREATE OR REPLACE VIEW q11 AS
SELECT
pair
,ydate
,pair||ydate prdate
,rownum rnum -- acts as t in my time-series
,clse
,LAG(clse,1,NULL)OVER(PARTITION BY pair ORDER BY pair,ydate) lg1
,LAG(clse,2,NULL)OVER(PARTITION BY pair ORDER BY pair,ydate) lg2
,LAG(clse,3,NULL)OVER(PARTITION BY pair ORDER BY pair,ydate) lg3
,LAG(clse,4,NULL)OVER(PARTITION BY pair ORDER BY pair,ydate) lg4
,LAG(clse,5,NULL)OVER(PARTITION BY pair ORDER BY pair,ydate) lg5
,LAG(clse,6,NULL)OVER(PARTITION BY pair ORDER BY pair,ydate) lg6
,LAG(clse,7,NULL)OVER(PARTITION BY pair ORDER BY pair,ydate) lg7
,LAG(clse,8,NULL)OVER(PARTITION BY pair ORDER BY pair,ydate) lg8
,LAG(clse,9,NULL)OVER(PARTITION BY pair ORDER BY pair,ydate) lg9
,LAG(clse,12,NULL)OVER(PARTITION BY pair ORDER BY pair,ydate) lg12
,LAG(clse,18,NULL)OVER(PARTITION BY pair ORDER BY pair,ydate) lg18
,LAG(clse,24,NULL)OVER(PARTITION BY pair ORDER BY pair,ydate) lg24
,LAG(clse,72,NULL)OVER(PARTITION BY pair ORDER BY pair,ydate) lg72
,NTILE(12) OVER (PARTITION BY pair ORDER BY (mx-opn))mxopnnt
,NTILE(12) OVER (PARTITION BY pair ORDER BY (mx-mn))mxmnnt
,NTILE(12) OVER (PARTITION BY pair ORDER BY (mx-clse))mxclsent
,NTILE(12) OVER (PARTITION BY pair ORDER BY vol)volnt
,LEAD(clse,1,NULL)OVER(PARTITION BY pair ORDER BY pair,ydate) ld1
,LEAD(clse,2,NULL)OVER(PARTITION BY pair ORDER BY pair,ydate) ld2
,LEAD(clse,3,NULL)OVER(PARTITION BY pair ORDER BY pair,ydate) ld3
,LEAD(clse,4,NULL)OVER(PARTITION BY pair ORDER BY pair,ydate) ld4
FROM hourly
ORDER BY ydate
/
