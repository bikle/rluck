--
-- jpy10.sql
--

-- Creates views and tables for demonstrating SVM.

CREATE OR REPLACE VIEW jpy10 AS
SELECT
pair
,ydate
,prdate
,clse
-- Derive some attributes from clse (the latest price of USD/JPY):
,MIN(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*6 PRECEDING AND CURRENT ROW)min6
--
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*6 PRECEDING AND CURRENT ROW)avg6
--
,MAX(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*6 PRECEDING AND CURRENT ROW)max6
,LEAD(clse,12*6,NULL)OVER(PARTITION BY pair ORDER BY ydate)ld6
FROM di5min WHERE pair LIKE'%jpy%'
-- I only want to see the last 95 days of data:
AND ydate > sysdate - 95
ORDER BY ydate
/

-- rpt

SELECT
pair
,COUNT(pair)
,MIN(clse),MAX(clse)
,MIN(avg6),MAX(avg6)
,MIN(ydate),MAX(ydate)
FROM jpy10
GROUP BY pair
/

-- Derive trend, clse-relations, moving correlation of clse, and date related params:
DROP TABLE jpy12;
CREATE TABLE jpy12 COMPRESS AS
SELECT
pair
,ydate
,prdate
,clse
-- g6 is important. I want to predict g6:
,ld6 - clse g6
,SIGN(avg6 - LAG(avg6,2,NULL)OVER(PARTITION BY pair ORDER BY ydate))trend
-- I want more attributes from the ones I derived above:
-- clse relation to moving-min
,clse-min6  cm6  
-- clse relation to moving-avg
,clse-avg6  ca6  
-- clse relation to moving-max
,clse-max6  cx6  
-- Derive date related attributes:
,0+TO_CHAR( ROUND(ydate,'HH24'),'HH24')hh
,0+TO_CHAR(ydate,'D')d
,0+TO_CHAR(ydate,'W')w
-- mpm stands for minutes-past-midnight:
,ROUND( (ydate - trunc(ydate))*24*60 )mpm
-- mph stands for minutes-past-hour:
,0+TO_CHAR(ydate,'MI')mph
FROM jpy10
ORDER BY ydate
/

-- rpt

SELECT
pair
,COUNT(pair)
,MIN(clse),MAX(clse)
,MIN(ydate),MAX(ydate)
FROM jpy12
GROUP BY pair
/

-- Prepare for derivation of NTILE based params:

DROP TABLE jpy14;
CREATE TABLE jpy14 COMPRESS AS
SELECT
pair
,ydate
,prdate
,clse
,g6
,CASE WHEN g6 IS NULL THEN NULL WHEN g6 > 0.0012 THEN 'up' ELSE 'nup' END gatt
,CASE WHEN g6 IS NULL THEN NULL WHEN g6< -0.0012 THEN 'up' ELSE 'nup' END gattn
,CASE WHEN trend IS NULL THEN 1
      WHEN trend =0      THEN 1
      ELSE trend END trend
,cm6  
-- 
,ca6  
--
,cx6  
--
,hh
,d
,w
,mpm
,mph
FROM jpy12
ORDER BY ydate
/

-- rpt

SELECT
pair
,trend
,gatt
,COUNT(pair)
,AVG(g6)
FROM jpy14
GROUP BY pair,trend,gatt
ORDER BY pair,trend,gatt
/

exit


-- Derive NTILE based params:

DROP TABLE jpy16;
CREATE TABLE jpy16 COMPRESS AS
SELECT
pair
,ydate
,prdate
,clse
,g6
,gatt
,gattn
,trend
,NTILE(9)OVER(PARTITION BY trend,pair ORDER BY cm4  )att00
,NTILE(9)OVER(PARTITION BY trend,pair ORDER BY cm6  )att01
,NTILE(9)OVER(PARTITION BY trend,pair ORDER BY cm8  )att02
,NTILE(9)OVER(PARTITION BY trend,pair ORDER BY cm10 )att03
,NTILE(9)OVER(PARTITION BY trend,pair ORDER BY cm12 )att04
,NTILE(9)OVER(PARTITION BY trend,pair ORDER BY cm14 )att05
,NTILE(9)OVER(PARTITION BY trend,pair ORDER BY cm16 )att06
,NTILE(9)OVER(PARTITION BY trend,pair ORDER BY cm18 )att07
,NTILE(9)OVER(PARTITION BY trend,pair ORDER BY ca4  )att08
,NTILE(9)OVER(PARTITION BY trend,pair ORDER BY ca6  )att09
,NTILE(9)OVER(PARTITION BY trend,pair ORDER BY ca8  )att10
,NTILE(9)OVER(PARTITION BY trend,pair ORDER BY ca10 )att11
,NTILE(9)OVER(PARTITION BY trend,pair ORDER BY ca12 )att12
,NTILE(9)OVER(PARTITION BY trend,pair ORDER BY ca14 )att13
,NTILE(9)OVER(PARTITION BY trend,pair ORDER BY ca16 )att14
,NTILE(9)OVER(PARTITION BY trend,pair ORDER BY ca18 )att15
,NTILE(9)OVER(PARTITION BY trend,pair ORDER BY cx4  )att16
,NTILE(9)OVER(PARTITION BY trend,pair ORDER BY cx6  )att17
,NTILE(9)OVER(PARTITION BY trend,pair ORDER BY cx8  )att18
,NTILE(9)OVER(PARTITION BY trend,pair ORDER BY cx10 )att19
,NTILE(9)OVER(PARTITION BY trend,pair ORDER BY cx12 )att20
,NTILE(9)OVER(PARTITION BY trend,pair ORDER BY cx14 )att21
,NTILE(9)OVER(PARTITION BY trend,pair ORDER BY cx16 )att22
,NTILE(9)OVER(PARTITION BY trend,pair ORDER BY cx18 )att23
,NTILE(9)OVER(PARTITION BY trend,pair ORDER BY crr4 )att24
,NTILE(9)OVER(PARTITION BY trend,pair ORDER BY crr6 )att25
,NTILE(9)OVER(PARTITION BY trend,pair ORDER BY crr8 )att26
,NTILE(9)OVER(PARTITION BY trend,pair ORDER BY crr10)att27
,NTILE(9)OVER(PARTITION BY trend,pair ORDER BY crr12)att28
,NTILE(9)OVER(PARTITION BY trend,pair ORDER BY crr14)att29
,NTILE(9)OVER(PARTITION BY trend,pair ORDER BY crr16)att30
,NTILE(9)OVER(PARTITION BY trend,pair ORDER BY crr18)att31
,hh  att32
,d   att33
,w   att34
,mpm att35
,mph att36
,trend att37
FROM jpy14
ORDER BY ydate
/

-- rpt

SELECT
pair
,trend
,gatt
,COUNT(pair)
,AVG(g6)
FROM jpy16
GROUP BY pair,trend,gatt
ORDER BY pair,trend,gatt
/

DROP TABLE modsrc;
CREATE TABLE modsrc COMPRESS AS
SELECT
pair       
,ydate      
,prdate     
,trend      
,g6
,gatt
,gattn
FROM jpy16
/

ANALYZE TABLE modsrc COMPUTE STATISTICS;

DROP   TABLE jpy_ms610 ;
CREATE TABLE jpy_ms610 COMPRESS AS
SELECT
ydate
,trend jpy_trend
,g6    jpy_g6
,gatt  jpy_gatt
,gattn jpy_gattn
FROM modsrc
/

ANALYZE TABLE jpy_ms610 COMPUTE STATISTICS;

-- I need a copy of the attributes:


DROP   TABLE jpy_att;
CREATE TABLE jpy_att COMPRESS AS
SELECT
ydate
,att00 jpy_att00
,att01 jpy_att01
,att02 jpy_att02
,att03 jpy_att03
,att04 jpy_att04
,att05 jpy_att05
,att06 jpy_att06
,att07 jpy_att07
,att08 jpy_att08
,att09 jpy_att09
,att10 jpy_att10
,att11 jpy_att11
,att12 jpy_att12
,att13 jpy_att13
,att14 jpy_att14
,att15 jpy_att15
,att16 jpy_att16
,att17 jpy_att17
,att18 jpy_att18
,att19 jpy_att19
,att20 jpy_att20
,att21 jpy_att21
,att22 jpy_att22
,att23 jpy_att23
,att24 jpy_att24
,att25 jpy_att25
,att26 jpy_att26
,att27 jpy_att27
,att28 jpy_att28
,att29 jpy_att29
,att30 jpy_att30
,att31 jpy_att31
,att32 jpy_att32
,att33 jpy_att33
,att34 jpy_att34
,att35 jpy_att35
,att36 jpy_att36
,att37 jpy_att37
FROM jpy16
/

ANALYZE TABLE jpy_att COMPUTE STATISTICS;

-- rpt 
SELECT COUNT(*)FROM jpy10;
SELECT COUNT(*)FROM jpy_att;

