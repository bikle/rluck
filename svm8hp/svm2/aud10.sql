--
-- aud10.sql
--

-- Creates views and tables for backtesting a forex SVM strategy

PURGE RECYCLEBIN;

-- I created di5min here:
-- /pt/s/rlk/svm8hp/update_di5min.sql

CREATE OR REPLACE VIEW q11 AS
SELECT
pair
,ydate
,prdate
,rownum rnum -- acts as t in my time-series
,clse
,LAG(clse,12*6 ,NULL)OVER(PARTITION BY pair ORDER BY ydate)lg6
,LAG(clse,12*8 ,NULL)OVER(PARTITION BY pair ORDER BY ydate)lg8
,LAG(clse,12*10,NULL)OVER(PARTITION BY pair ORDER BY ydate)lg10
,LAG(clse,12*12,NULL)OVER(PARTITION BY pair ORDER BY ydate)lg12
,LAG(clse,12*14,NULL)OVER(PARTITION BY pair ORDER BY ydate)lg14
,LAG(clse,12*16,NULL)OVER(PARTITION BY pair ORDER BY ydate)lg16
,LAG(clse,12*18,NULL)OVER(PARTITION BY pair ORDER BY ydate)lg18
,LAG(clse,12*20,NULL)OVER(PARTITION BY pair ORDER BY ydate)lg20
,LAG(clse,12*22,NULL)OVER(PARTITION BY pair ORDER BY ydate)lg22
,LAG(clse,12*24,NULL)OVER(PARTITION BY pair ORDER BY ydate)lg24
,LAG(clse,12*26,NULL)OVER(PARTITION BY pair ORDER BY ydate)lg26
,LAG(clse,12*28,NULL)OVER(PARTITION BY pair ORDER BY ydate)lg28
,LAG(clse,12*32,NULL)OVER(PARTITION BY pair ORDER BY ydate)lg32
,LEAD(clse,12*8,NULL)OVER(PARTITION BY pair ORDER BY ydate)ld8
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
,ld8
,CASE WHEN(clse-lg8)>0 then 1 ELSE -1 END trend
-- step by 2
,clse-lg6  d06
,lg6 -lg8  d68
,lg8 -lg10 d810
,lg10-lg12 d1012
,lg12-lg14 d1214
,lg14-lg16 d1416
,lg16-lg18 d1618
-- step by 4
,lg6 -lg10 d610
,lg8 -lg12 d812
,lg10-lg14 d1014
,lg12-lg16 d1216
--
,ABS(clse-lg6 )dc6 
,ABS(clse-lg8 )dc8 
,ABS(clse-lg10)dc10
,ABS(clse-lg12)dc12
,ABS(clse-lg14)dc14
,ABS(clse-lg16)dc16
,ABS(clse-lg18)dc18
,ABS(clse-lg20)dc20
,ABS(clse-lg22)dc22
,(ld8-clse) ug8
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*6  PRECEDING AND CURRENT ROW)crr6 
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*8  PRECEDING AND CURRENT ROW)crr8 
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*10 PRECEDING AND CURRENT ROW)crr10
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*12 PRECEDING AND CURRENT ROW)crr12
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*14 PRECEDING AND CURRENT ROW)crr14
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*16 PRECEDING AND CURRENT ROW)crr16
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*18 PRECEDING AND CURRENT ROW)crr18
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*20 PRECEDING AND CURRENT ROW)crr20
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*22 PRECEDING AND CURRENT ROW)crr22
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*24 PRECEDING AND CURRENT ROW)crr24
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*26 PRECEDING AND CURRENT ROW)crr26
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*28 PRECEDING AND CURRENT ROW)crr28
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*32 PRECEDING AND CURRENT ROW)crr32
,0+TO_CHAR( ROUND(ydate,'HH24'),'HH24')hh
,0+TO_CHAR(ydate,'D')d
,0+TO_CHAR(ydate,'W')w
,ROUND( (ydate - trunc(ydate))*24*60 )mpm
FROM q11
-- I dont want any NULL values from the LAG() functions:
WHERE lg32 > 0
ORDER BY pair,ydate
/

-- rpt
SELECT trend,COUNT(prdate)FROM q13 GROUP BY trend;

exit

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
-- date related integers: hour of day, day of week, week of month, minutes-past-midnight:
,hh    att28
,d     att29
,w     att30
,mpm   att31
,trend att32
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
,gattn aud_gattn
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
,att32 aud_att32
FROM q15
/

ANALYZE TABLE aud_att COMPUTE STATISTICS;

-- rpt 
SELECT COUNT(*)FROM aud_att;

exit
