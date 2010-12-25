--
-- gbp410.sql
--

-- Creates views and tables for backtesting a forex SVM strategy

PURGE RECYCLEBIN;

-- I created di5min here:
-- /pt/s/rlk/svm8hp/update_di5min.sql

CREATE OR REPLACE VIEW svm4102 AS
SELECT
pair
,ydate
,prdate
,rownum rnum -- acts as t in my time-series
,clse
-- Derive a bunch of attributes from clse, the latest price:
,MIN(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*2 PRECEDING AND CURRENT ROW)min2
,MIN(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*3 PRECEDING AND CURRENT ROW)min3
,MIN(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*4 PRECEDING AND CURRENT ROW)min4
,MIN(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*6 PRECEDING AND CURRENT ROW)min6
,MIN(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*8 PRECEDING AND CURRENT ROW)min8
,MIN(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*10 PRECEDING AND CURRENT ROW)min10
,MIN(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*12 PRECEDING AND CURRENT ROW)min12
,MIN(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*14 PRECEDING AND CURRENT ROW)min14
--
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*2 PRECEDING AND CURRENT ROW)avg2
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*3 PRECEDING AND CURRENT ROW)avg3
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*4 PRECEDING AND CURRENT ROW)avg4
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*6 PRECEDING AND CURRENT ROW)avg6
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*8 PRECEDING AND CURRENT ROW)avg8
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*10 PRECEDING AND CURRENT ROW)avg10
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*12 PRECEDING AND CURRENT ROW)avg12
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*14 PRECEDING AND CURRENT ROW)avg14
--
,MAX(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*2 PRECEDING AND CURRENT ROW)max2
,MAX(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*3 PRECEDING AND CURRENT ROW)max3
,MAX(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*4 PRECEDING AND CURRENT ROW)max4
,MAX(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*6 PRECEDING AND CURRENT ROW)max6
,MAX(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*8 PRECEDING AND CURRENT ROW)max8
,MAX(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*10 PRECEDING AND CURRENT ROW)max10
,MAX(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*12 PRECEDING AND CURRENT ROW)max12
,MAX(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*14 PRECEDING AND CURRENT ROW)max14
,LEAD(clse,12*4,NULL)OVER(PARTITION BY pair ORDER BY ydate)ld4
FROM di5min
WHERE pair LIKE'%gbp%'
AND ydate > sysdate - 190
ORDER BY ydate
/

-- rpt

SELECT
pair
,COUNT(pair)
,MIN(clse),MAX(clse)
,MIN(avg4),MAX(avg4)
,MIN(ydate),MAX(ydate)
FROM svm4102
GROUP BY pair
/

-- Derive trend, clse-relations, moving correlation of clse, and date related params:
DROP TABLE svm4122;
CREATE TABLE svm4122 COMPRESS AS
SELECT
pair
,ydate
,prdate
,clse
-- g4 is important. I want to predict g4:
,ld4 - clse g4
,SIGN(avg4 - LAG(avg4,2,NULL)OVER(PARTITION BY pair ORDER BY ydate))trend
-- I want more attributes from the ones I derived above:
-- clse relation to moving-min
,clse-min2  cm2  
,clse-min3  cm3  
,clse-min4  cm4  
,clse-min6  cm6  
,clse-min8  cm8  
,clse-min10 cm10 
,clse-min12 cm12 
,clse-min14 cm14 
-- clse relation to moving-avg
,clse-avg2  ca2  
,clse-avg3  ca3  
,clse-avg4  ca4  
,clse-avg6  ca6  
,clse-avg8  ca8  
,clse-avg10 ca10 
,clse-avg12 ca12 
,clse-avg14 ca14 
-- clse relation to moving-max
,clse-max2  cx2  
,clse-max3  cx3  
,clse-max4  cx4  
,clse-max6  cx6  
,clse-max8  cx8  
,clse-max10 cx10 
,clse-max12 cx12 
,clse-max14 cx14 
-- Derive more attributes.
-- I want to use CORR() here to help SVM see the shape of the series.
-- But COVAR_POP is more stable:
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*2  PRECEDING AND CURRENT ROW)crr2 
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*3  PRECEDING AND CURRENT ROW)crr3 
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*4  PRECEDING AND CURRENT ROW)crr4 
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*6  PRECEDING AND CURRENT ROW)crr6 
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*8  PRECEDING AND CURRENT ROW)crr8 
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*10 PRECEDING AND CURRENT ROW)crr10
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*12 PRECEDING AND CURRENT ROW)crr12
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*14 PRECEDING AND CURRENT ROW)crr14
-- Derive date related attributes:
,0+TO_CHAR( ROUND(ydate,'HH24'),'HH24')hh
,0+TO_CHAR(ydate,'D')d
,0+TO_CHAR(ydate,'W')w
-- mpm stands for minutes-past-midnight:
,ROUND( (ydate - trunc(ydate))*24*60 )mpm
-- mph stands for minutes-past-hour:
,0+TO_CHAR(ydate,'MI')mph
FROM svm4102
ORDER BY ydate
/

-- rpt

SELECT
pair
,COUNT(pair)
,MIN(clse),MAX(clse)
,MIN(ydate),MAX(ydate)
FROM svm4122
GROUP BY pair
/

-- Prepare for derivation of NTILE based params:

DROP TABLE svm4142;
CREATE TABLE svm4142 COMPRESS AS
SELECT
pair
,ydate
,prdate
,clse
,g4
,CASE WHEN g4 IS NULL THEN NULL WHEN g4 > 0.0010 THEN 'up' ELSE 'nup' END gatt
,CASE WHEN g4 IS NULL THEN NULL WHEN g4< -0.0010 THEN 'up' ELSE 'nup' END gattn
,CASE WHEN trend IS NULL THEN 1
      WHEN trend =0      THEN 1
      ELSE trend END trend
,cm2
,cm3  
,cm4  
,cm6  
,cm8  
,cm10 
,cm12 
,cm14 
-- 
,ca2  
,ca3  
,ca4  
,ca6  
,ca8  
,ca10 
,ca12 
,ca14 
--
,cx2  
,cx3  
,cx4  
,cx6  
,cx8  
,cx10 
,cx12 
,cx14 
--
,crr2 
,crr3 
,crr4 
,crr6 
,crr8 
,crr10
,crr12
,crr14
--
,hh
,d
,w
,mpm
,mph
FROM svm4122
ORDER BY ydate
/

-- rpt

SELECT
pair
,trend
,gatt
,COUNT(pair)
,AVG(g4)
FROM svm4142
GROUP BY pair,trend,gatt
ORDER BY pair,trend,gatt
/


-- Derive NTILE based params:

DROP TABLE svm4162;
CREATE TABLE svm4162 COMPRESS AS
SELECT
pair
,ydate
,prdate
,clse
,g4
,gatt
,gattn
,trend
,NTILE(9)OVER(PARTITION BY trend,pair ORDER BY cm4  )att00
,NTILE(9)OVER(PARTITION BY trend,pair ORDER BY cm6  )att01
,NTILE(9)OVER(PARTITION BY trend,pair ORDER BY cm8  )att02
,NTILE(9)OVER(PARTITION BY trend,pair ORDER BY cm10 )att03
,NTILE(9)OVER(PARTITION BY trend,pair ORDER BY cm12 )att04
,NTILE(9)OVER(PARTITION BY trend,pair ORDER BY cm14 )att05
,NTILE(9)OVER(PARTITION BY trend,pair ORDER BY cm2  )att06
,NTILE(9)OVER(PARTITION BY trend,pair ORDER BY cm3  )att07
,NTILE(9)OVER(PARTITION BY trend,pair ORDER BY ca4  )att08
,NTILE(9)OVER(PARTITION BY trend,pair ORDER BY ca6  )att09
,NTILE(9)OVER(PARTITION BY trend,pair ORDER BY ca8  )att10
,NTILE(9)OVER(PARTITION BY trend,pair ORDER BY ca10 )att11
,NTILE(9)OVER(PARTITION BY trend,pair ORDER BY ca12 )att12
,NTILE(9)OVER(PARTITION BY trend,pair ORDER BY ca14 )att13
,NTILE(9)OVER(PARTITION BY trend,pair ORDER BY ca2  )att14
,NTILE(9)OVER(PARTITION BY trend,pair ORDER BY ca3  )att15
,NTILE(9)OVER(PARTITION BY trend,pair ORDER BY cx4  )att16
,NTILE(9)OVER(PARTITION BY trend,pair ORDER BY cx6  )att17
,NTILE(9)OVER(PARTITION BY trend,pair ORDER BY cx8  )att18
,NTILE(9)OVER(PARTITION BY trend,pair ORDER BY cx10 )att19
,NTILE(9)OVER(PARTITION BY trend,pair ORDER BY cx12 )att20
,NTILE(9)OVER(PARTITION BY trend,pair ORDER BY cx14 )att21
,NTILE(9)OVER(PARTITION BY trend,pair ORDER BY cx2  )att22
,NTILE(9)OVER(PARTITION BY trend,pair ORDER BY cx3  )att23
,NTILE(9)OVER(PARTITION BY trend,pair ORDER BY crr4 )att24
,NTILE(9)OVER(PARTITION BY trend,pair ORDER BY crr6 )att25
,NTILE(9)OVER(PARTITION BY trend,pair ORDER BY crr8 )att26
,NTILE(9)OVER(PARTITION BY trend,pair ORDER BY crr10)att27
,NTILE(9)OVER(PARTITION BY trend,pair ORDER BY crr12)att28
,NTILE(9)OVER(PARTITION BY trend,pair ORDER BY crr14)att29
,NTILE(9)OVER(PARTITION BY trend,pair ORDER BY crr2 )att30
,NTILE(9)OVER(PARTITION BY trend,pair ORDER BY crr3 )att31
,hh  att32
,d   att33
,w   att34
,mpm att35
,mph att36
,trend att37
FROM svm4142
ORDER BY ydate
/

-- rpt

SELECT
pair
,trend
,gatt
,COUNT(pair)
,AVG(g4)
FROM svm4162
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
,g4
,gatt
,gattn
FROM svm4162
/

ANALYZE TABLE modsrc COMPUTE STATISTICS;

DROP   TABLE gbp_ms410 ;
CREATE TABLE gbp_ms410 COMPRESS AS
SELECT
ydate
,trend gbp_trend
,g4    gbp_g4
,gatt  gbp_gatt
,gattn gbp_gattn
FROM modsrc
/

ANALYZE TABLE gbp_ms410 COMPUTE STATISTICS;

-- I need a copy of the attributes:


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
,att37 gbp_att37
FROM svm4162
/

ANALYZE TABLE gbp_att COMPUTE STATISTICS;

-- rpt 
SELECT COUNT(*)FROM svm4102;
SELECT COUNT(*)FROM gbp_att;

