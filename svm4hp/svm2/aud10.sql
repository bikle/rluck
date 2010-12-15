--
-- aud10.sql
--

-- Creates views and tables for backtesting a forex SVM strategy

PURGE RECYCLEBIN;

-- I created di5min here:
-- /pt/s/rlk/svm4hp/update_di5min.sql

CREATE OR REPLACE VIEW q11 AS
SELECT
pair
,ydate
,prdate
,rownum rnum -- acts as t in my time-series
,clse
,LAG(clse,6*1,NULL)OVER(PARTITION BY pair ORDER BY ydate) lg1
,LAG(clse,6*2,NULL)OVER(PARTITION BY pair ORDER BY ydate) lg2
,LAG(clse,6*3,NULL)OVER(PARTITION BY pair ORDER BY ydate) lg3
,LAG(clse,6*4,NULL)OVER(PARTITION BY pair ORDER BY ydate) lg4
,LAG(clse,6*5,NULL)OVER(PARTITION BY pair ORDER BY ydate) lg5
,LAG(clse,6*6,NULL)OVER(PARTITION BY pair ORDER BY ydate) lg6
,LAG(clse,6*7,NULL)OVER(PARTITION BY pair ORDER BY ydate) lg7
,LAG(clse,6*8,NULL)OVER(PARTITION BY pair ORDER BY ydate) lg8
,LAG(clse,6*9,NULL)OVER(PARTITION BY pair ORDER BY ydate) lg9
,LAG(clse,6*12,NULL)OVER(PARTITION BY pair ORDER BY ydate) lg12
,LAG(clse,6*18,NULL)OVER(PARTITION BY pair ORDER BY ydate) lg18
,LAG(clse,6*24,NULL)OVER(PARTITION BY pair ORDER BY ydate) lg24
,LAG(clse,6*72,NULL)OVER(PARTITION BY pair ORDER BY ydate) lg72
,LEAD(clse,6*4,NULL)OVER(PARTITION BY pair ORDER BY ydate) ld4
FROM di5min WHERE pair LIKE'%aud%'
ORDER BY ydate
/

-- rpt
SELECT pair,COUNT(ydate) FROM q11 GROUP BY pair;

-- Calc deltas and gains
DROP TABLE q13;

CREATE TABLE q13 COMPRESS AS
SELECT
pair
,ydate
,prdate
,rnum
,lg4
,lg8
,lg12
,ld4
,CASE WHEN(clse-lg12)>0 then 1 ELSE -1 END trend
-- step by 1
,clse-lg1 d01
,lg1-lg2  d12
,lg2-lg3  d23
,lg3-lg4  d34
,lg4-lg5  d45
,lg5-lg6  d56
,lg6-lg7  d67
,lg7-lg8  d78
,lg8-lg9  d89
-- step by 2
,clse-lg2 d02
,lg2-lg4 d24
,lg4-lg6 d46
,lg6-lg8 d68
-- step by 3
,clse-lg3 d03
,lg3-lg6  d36
,lg6-lg9  d69
,lg9-lg12 d912
-- step by 4
,clse-lg4 d04
,lg4-lg8  d48
,lg8-lg12 d812
,lg6-lg12 d612
,lg12-lg18 d1218
--
,ABS(clse-lg1)dc1
,ABS(clse-lg2)dc2
,ABS(clse-lg3)dc3
,ABS(clse-lg4)dc4
,ABS(clse-lg5)dc5
,ABS(clse-lg6)dc6
,ABS(clse-lg7)dc7
,ABS(clse-lg8)dc8
,ABS(clse-lg9)dc9
,ABS(clse-lg12)dc12
,ABS(clse-lg18)dc18
,ABS(clse-lg24)dc24
,ABS(clse-lg72)dc72
,(ld4-clse) ug4
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 6*2  PRECEDING AND CURRENT ROW)crr2
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 6*3  PRECEDING AND CURRENT ROW)crr3
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 6*4  PRECEDING AND CURRENT ROW)crr4
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 6*5  PRECEDING AND CURRENT ROW)crr5
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 6*6  PRECEDING AND CURRENT ROW)crr6
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 6*7  PRECEDING AND CURRENT ROW)crr7
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 6*8  PRECEDING AND CURRENT ROW)crr8
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 6*9  PRECEDING AND CURRENT ROW)crr9
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 6*12 PRECEDING AND CURRENT ROW)crr12
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 6*24 PRECEDING AND CURRENT ROW)crr24
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 6*72 PRECEDING AND CURRENT ROW)crr72
,0+TO_CHAR(ydate,'HH24')hh
,0+TO_CHAR(ydate,'D')d
,0+TO_CHAR(ydate,'W')w
FROM q11
-- I dont want any NULL values from the LAG() functions:
WHERE lg72 > 0
ORDER BY pair,ydate
/

-- rpt
SELECT trend,COUNT(prdate)FROM q13 GROUP BY trend;

-- Calc gains and ntiles
DROP TABLE q15;
CREATE TABLE q15 COMPRESS AS
SELECT
pair
,ydate
,prdate -- Should be unique
,trend -- +1 or -1
,dc12 -- next statement needs this
-- Use NTILE() to derive some attributes
,NTILE(6)OVER(PARTITION BY trend,pair ORDER BY ABS(d12))           att00
,NTILE(6)OVER(PARTITION BY trend,pair ORDER BY ABS(d23))           att01
,NTILE(6)OVER(PARTITION BY trend,pair ORDER BY ABS(d34))           att02
,NTILE(6)OVER(PARTITION BY trend,pair ORDER BY ABS(d45))           att03
,NTILE(6)OVER(PARTITION BY trend,pair ORDER BY ABS(d56))           att04
,NTILE(6)OVER(PARTITION BY trend,pair ORDER BY ABS(d67))           att05
,NTILE(6)OVER(PARTITION BY trend,pair ORDER BY ABS(d78))           att06
,NTILE(6)OVER(PARTITION BY trend,pair ORDER BY ABS(d89))           att07
,NTILE(6)OVER(PARTITION BY trend,pair ORDER BY ABS(d912))          att08
,NTILE(6)OVER(PARTITION BY trend,pair ORDER BY dc2)                att09
,NTILE(6)OVER(PARTITION BY trend,pair ORDER BY dc3)                att10
,NTILE(6)OVER(PARTITION BY trend,pair ORDER BY dc4)                att11
,NTILE(6)OVER(PARTITION BY trend,pair ORDER BY dc5)                att12
,NTILE(6)OVER(PARTITION BY trend,pair ORDER BY dc6)                att13
,NTILE(6)OVER(PARTITION BY trend,pair ORDER BY dc7)                att14 
,NTILE(6)OVER(PARTITION BY trend,pair ORDER BY dc8)                att15 
,NTILE(6)OVER(PARTITION BY trend,pair ORDER BY dc9)                att16 
,NTILE(6)OVER(PARTITION BY trend,pair ORDER BY dc12)               att17 
,NTILE(6)OVER(PARTITION BY trend,pair ORDER BY dc24)               att18 
,NTILE(6)OVER(PARTITION BY trend,pair ORDER BY dc72)               att19 
,NTILE(6)OVER(PARTITION BY trend,pair ORDER BY ABS(ROUND(crr2,7))) att20
,NTILE(6)OVER(PARTITION BY trend,pair ORDER BY ABS(ROUND(crr3,7))) att21
,NTILE(6)OVER(PARTITION BY trend,pair ORDER BY ABS(ROUND(crr4,7))) att22
,NTILE(6)OVER(PARTITION BY trend,pair ORDER BY ABS(ROUND(crr5,7))) att23
,NTILE(6)OVER(PARTITION BY trend,pair ORDER BY ABS(ROUND(crr6,7))) att24
,NTILE(6)OVER(PARTITION BY trend,pair ORDER BY ABS(ROUND(crr12,7)))att25
,NTILE(6)OVER(PARTITION BY trend,pair ORDER BY ABS(ROUND(crr24,7)))att26
,NTILE(6)OVER(PARTITION BY trend,pair ORDER BY ABS(ROUND(crr72,7)))att27
-- date related integers: hour of day, day of week, week of month:
,hh    att28
,d     att29
,w     att30
,trend att31
,ug4 g4
,CASE WHEN ug4 IS NULL THEN NULL WHEN ug4 > 0.0006 THEN 'up' ELSE 'nup' END gatt
,CASE WHEN ug4 IS NULL THEN NULL WHEN ug4< -0.0006 THEN 'up' ELSE 'nup' END gattn
FROM q13
ORDER BY pair,ydate
/

-- rpt
SELECT pair,trend,gatt,gattn,AVG(g4),COUNT(g4),CORR(dc12,g4)FROM q15
GROUP BY pair,trend,gatt,gattn
ORDER BY pair,trend,gatt,gattn
/

-- rpt
SELECT pair,max(ydate)from q15 group by pair;

DROP TABLE modsrc;
CREATE TABLE modsrc COMPRESS AS
SELECT
pair       
,ydate      
,prdate     
,trend      
,g4
,gatt
,gattn
,dc12
FROM q15
/

ANALYZE TABLE modsrc COMPUTE STATISTICS;

-- rpt

SELECT COUNT(pair)FROM q11;
SELECT COUNT(pair)FROM q13;
SELECT COUNT(pair)FROM q15;
SELECT COUNT(pair)FROM modsrc;

SELECT pair,trend,gatt,gattn,AVG(g4),COUNT(g4),CORR(dc12,g4)FROM modsrc
GROUP BY pair,trend,gatt,gattn
ORDER BY pair,trend,gatt,gattn
/

DROP   TABLE aud_ms10 ;
CREATE TABLE aud_ms10 COMPRESS AS
SELECT
ydate
,trend aud_trend
,g4    aud_g4
,gatt  aud_gatt
,gattn  aud_gattn
FROM modsrc
/

ANALYZE TABLE aud_ms10 COMPUTE STATISTICS;

-- rpt
SELECT trend,MIN(ydate),MAX(ydate),COUNT(g4),MIN(g4),MAX(g4)FROM modsrc GROUP BY trend;
SELECT aud_trend,MIN(ydate),MAX(ydate),COUNT(aud_trend),MIN(aud_g4),MAX(aud_g4)FROM aud_ms10 GROUP BY aud_trend;

-- I need a copy of q15 attributes

DROP   TABLE aud_att;
CREATE TABLE aud_att COMPRESS AS
SELECT
ydate
,att00 aud_att00
,att01 aud_att01
,att02 aud_att02
,att03 aud_att03
,att04 aud_att04
,att05 aud_att05
,att06 aud_att06
,att07 aud_att07
,att08 aud_att08
,att09 aud_att09
,att10 aud_att10
,att11 aud_att11
,att12 aud_att12
,att13 aud_att13
,att14 aud_att14
,att15 aud_att15
,att16 aud_att16
,att17 aud_att17
,att18 aud_att18
,att19 aud_att19
,att20 aud_att20
,att21 aud_att21
,att22 aud_att22
,att23 aud_att23
,att24 aud_att24
,att25 aud_att25
,att26 aud_att26
,att27 aud_att27
,att28 aud_att28
,att29 aud_att29
,att30 aud_att30
,att31 aud_att31
FROM q15
/

ANALYZE TABLE aud_att COMPUTE STATISTICS;

-- rpt 
SELECT COUNT(*)FROM aud_att;

exit
