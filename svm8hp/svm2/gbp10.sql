--
-- gbp10.sql
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
FROM di5min WHERE pair LIKE'%gbp%'
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
-- mpm stands for minutes-past-midnight:
,ROUND( (ydate - trunc(ydate))*24*60 )mpm
FROM q11
-- I dont want any NULL values from the LAG() functions:
WHERE lg32 > 0
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
-- Use NTILE() to derive some attributes
,NTILE(6)OVER(PARTITION BY trend,pair ORDER BY ABS(d68	))         att00 
,NTILE(6)OVER(PARTITION BY trend,pair ORDER BY ABS(d810	))         att01 
,NTILE(6)OVER(PARTITION BY trend,pair ORDER BY ABS(d1012))         att02 
,NTILE(6)OVER(PARTITION BY trend,pair ORDER BY ABS(d1214))         att03 
,NTILE(6)OVER(PARTITION BY trend,pair ORDER BY ABS(d1416))         att04 
,NTILE(6)OVER(PARTITION BY trend,pair ORDER BY ABS(d1618))         att05 
,NTILE(6)OVER(PARTITION BY trend,pair ORDER BY ABS(d610	))         att06 
,NTILE(6)OVER(PARTITION BY trend,pair ORDER BY ABS(d812	))         att07 
,NTILE(6)OVER(PARTITION BY trend,pair ORDER BY ABS(d1014))         att08 
,NTILE(6)OVER(PARTITION BY trend,pair ORDER BY ABS(d1216))         att09 
,NTILE(6)OVER(PARTITION BY trend,pair ORDER BY dc6 )               att10 
,NTILE(6)OVER(PARTITION BY trend,pair ORDER BY dc8 )               att11 
,NTILE(6)OVER(PARTITION BY trend,pair ORDER BY dc10)               att12 
,NTILE(6)OVER(PARTITION BY trend,pair ORDER BY dc12)               att13 
,NTILE(6)OVER(PARTITION BY trend,pair ORDER BY dc14)               att14 
,NTILE(6)OVER(PARTITION BY trend,pair ORDER BY dc16)               att15  
,NTILE(6)OVER(PARTITION BY trend,pair ORDER BY dc18)               att16  
,NTILE(6)OVER(PARTITION BY trend,pair ORDER BY dc20)               att17  
,NTILE(6)OVER(PARTITION BY trend,pair ORDER BY dc22)               att18  
,NTILE(6)OVER(PARTITION BY trend,pair ORDER BY ABS(ROUND(crr6 ,7)))att19 
,NTILE(6)OVER(PARTITION BY trend,pair ORDER BY ABS(ROUND(crr8 ,7)))att20 
,NTILE(6)OVER(PARTITION BY trend,pair ORDER BY ABS(ROUND(crr10,7)))att21 
,NTILE(6)OVER(PARTITION BY trend,pair ORDER BY ABS(ROUND(crr12,7)))att22 
,NTILE(6)OVER(PARTITION BY trend,pair ORDER BY ABS(ROUND(crr14,7)))att23 
,NTILE(6)OVER(PARTITION BY trend,pair ORDER BY ABS(ROUND(crr16,7)))att24 
,NTILE(6)OVER(PARTITION BY trend,pair ORDER BY ABS(ROUND(crr18,7)))att25 
,NTILE(6)OVER(PARTITION BY trend,pair ORDER BY ABS(ROUND(crr20,7)))att26 
,NTILE(6)OVER(PARTITION BY trend,pair ORDER BY ABS(ROUND(crr22,7)))att27 
,NTILE(6)OVER(PARTITION BY trend,pair ORDER BY ABS(ROUND(crr24,7)))att28 
,NTILE(6)OVER(PARTITION BY trend,pair ORDER BY ABS(ROUND(crr26,7)))att29 
,NTILE(6)OVER(PARTITION BY trend,pair ORDER BY ABS(ROUND(crr28,7)))att30 
,NTILE(6)OVER(PARTITION BY trend,pair ORDER BY ABS(ROUND(crr32,7)))att31 
-- date related integers: hour of day, day of week, week of month, minutes-past-midnight:
,hh    att32
,d     att33
,w     att34
,mpm   att35
,trend att36
,ug8 g8
,CASE WHEN ug8 IS NULL THEN NULL WHEN ug8 > 0.0020 THEN 'up' ELSE 'nup' END gatt
,CASE WHEN ug8 IS NULL THEN NULL WHEN ug8< -0.0020 THEN 'up' ELSE 'nup' END gattn
FROM q13
ORDER BY pair,ydate
/

-- rpt
SELECT pair,trend,gatt,gattn,AVG(g8),COUNT(g8)FROM q15
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
,g8
,gatt
,gattn
FROM q15
/

ANALYZE TABLE modsrc COMPUTE STATISTICS;

-- rpt

SELECT COUNT(pair)FROM q11;
SELECT COUNT(pair)FROM q13;
SELECT COUNT(pair)FROM q15;
SELECT COUNT(pair)FROM modsrc;

DROP   TABLE gbp_ms10 ;
CREATE TABLE gbp_ms10 COMPRESS AS
SELECT
ydate
,trend gbp_trend
,g8    gbp_g8
,gatt  gbp_gatt
,gattn gbp_gattn
FROM modsrc
/

ANALYZE TABLE gbp_ms10 COMPUTE STATISTICS;

-- rpt
SELECT trend,MIN(ydate),MAX(ydate),COUNT(g8),MIN(g8),MAX(g8)FROM modsrc GROUP BY trend;
SELECT gbp_trend,MIN(ydate),MAX(ydate),COUNT(gbp_trend),MIN(gbp_g8),MAX(gbp_g8)FROM gbp_ms10 GROUP BY gbp_trend;

-- I need a copy of q15 attributes

DROP   TABLE gbp_att;
CREATE TABLE gbp_att COMPRESS AS
SELECT
ydate
,att00 gbp_att00
,att01 gbp_att01
,att02 gbp_att02
,att03 gbp_att03
,att04 gbp_att04
,att05 gbp_att05
,att06 gbp_att06
,att07 gbp_att07
,att08 gbp_att08
,att09 gbp_att09
,att10 gbp_att10
,att11 gbp_att11
,att12 gbp_att12
,att13 gbp_att13
,att14 gbp_att14
,att15 gbp_att15
,att16 gbp_att16
,att17 gbp_att17
,att18 gbp_att18
,att19 gbp_att19
,att20 gbp_att20
,att21 gbp_att21
,att22 gbp_att22
,att23 gbp_att23
,att24 gbp_att24
,att25 gbp_att25
,att26 gbp_att26
,att27 gbp_att27
,att28 gbp_att28
,att29 gbp_att29
,att30 gbp_att30
,att31 gbp_att31
,att32 gbp_att32
,att33 gbp_att33
,att34 gbp_att34
,att35 gbp_att35
,att36 gbp_att36
FROM q15
/

ANALYZE TABLE gbp_att COMPUTE STATISTICS;

-- rpt 
SELECT COUNT(*)FROM gbp_att;

exit
