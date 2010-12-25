--
-- eur410.sql
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
WHERE pair LIKE'%eur%'
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

DROP   TABLE eur_ms410 ;
CREATE TABLE eur_ms410 COMPRESS AS
SELECT
ydate
,trend eur_trend
,g4    eur_g4
,gatt  eur_gatt
,gattn eur_gattn
FROM modsrc
/

ANALYZE TABLE eur_ms410 COMPUTE STATISTICS;

-- I need a copy of the attributes:


DROP   TABLE eur_att;
CREATE TABLE eur_att COMPRESS AS
SELECT
ydate
,att00 eur_att00
,att01 eur_att01
,att02 eur_att02
,att03 eur_att03
,att04 eur_att04
,att05 eur_att05
,att06 eur_att06
,att07 eur_att07
,att08 eur_att08
,att09 eur_att09
,att10 eur_att10
,att11 eur_att11
,att12 eur_att12
,att13 eur_att13
,att14 eur_att14
,att15 eur_att15
,att16 eur_att16
,att17 eur_att17
,att18 eur_att18
,att19 eur_att19
,att20 eur_att20
,att21 eur_att21
,att22 eur_att22
,att23 eur_att23
,att24 eur_att24
,att25 eur_att25
,att26 eur_att26
,att27 eur_att27
,att28 eur_att28
,att29 eur_att29
,att30 eur_att30
,att31 eur_att31
,att32 eur_att32
,att33 eur_att33
,att34 eur_att34
,att35 eur_att35
,att36 eur_att36
,att37 eur_att37
FROM svm4162
/

ANALYZE TABLE eur_att COMPUTE STATISTICS;

-- rpt 
SELECT COUNT(*)FROM svm4102;
SELECT COUNT(*)FROM eur_att;

--
-- aud410.sql
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
WHERE pair LIKE'%aud%'
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

DROP   TABLE aud_ms410 ;
CREATE TABLE aud_ms410 COMPRESS AS
SELECT
ydate
,trend aud_trend
,g4    aud_g4
,gatt  aud_gatt
,gattn aud_gattn
FROM modsrc
/

ANALYZE TABLE aud_ms410 COMPUTE STATISTICS;

-- I need a copy of the attributes:


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
,att33 aud_att33
,att34 aud_att34
,att35 aud_att35
,att36 aud_att36
,att37 aud_att37
FROM svm4162
/

ANALYZE TABLE aud_att COMPUTE STATISTICS;

-- rpt 
SELECT COUNT(*)FROM svm4102;
SELECT COUNT(*)FROM aud_att;

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

--
-- jpy410.sql
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
WHERE pair LIKE'%jpy%'
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

DROP   TABLE jpy_ms410 ;
CREATE TABLE jpy_ms410 COMPRESS AS
SELECT
ydate
,trend jpy_trend
,g4    jpy_g4
,gatt  jpy_gatt
,gattn jpy_gattn
FROM modsrc
/

ANALYZE TABLE jpy_ms410 COMPUTE STATISTICS;

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
FROM svm4162
/

ANALYZE TABLE jpy_att COMPUTE STATISTICS;

-- rpt 
SELECT COUNT(*)FROM svm4102;
SELECT COUNT(*)FROM jpy_att;

--
-- cad410.sql
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
WHERE pair LIKE'%cad%'
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

DROP   TABLE cad_ms410 ;
CREATE TABLE cad_ms410 COMPRESS AS
SELECT
ydate
,trend cad_trend
,g4    cad_g4
,gatt  cad_gatt
,gattn cad_gattn
FROM modsrc
/

ANALYZE TABLE cad_ms410 COMPUTE STATISTICS;

-- I need a copy of the attributes:


DROP   TABLE cad_att;
CREATE TABLE cad_att COMPRESS AS
SELECT
ydate
,att00 cad_att00
,att01 cad_att01
,att02 cad_att02
,att03 cad_att03
,att04 cad_att04
,att05 cad_att05
,att06 cad_att06
,att07 cad_att07
,att08 cad_att08
,att09 cad_att09
,att10 cad_att10
,att11 cad_att11
,att12 cad_att12
,att13 cad_att13
,att14 cad_att14
,att15 cad_att15
,att16 cad_att16
,att17 cad_att17
,att18 cad_att18
,att19 cad_att19
,att20 cad_att20
,att21 cad_att21
,att22 cad_att22
,att23 cad_att23
,att24 cad_att24
,att25 cad_att25
,att26 cad_att26
,att27 cad_att27
,att28 cad_att28
,att29 cad_att29
,att30 cad_att30
,att31 cad_att31
,att32 cad_att32
,att33 cad_att33
,att34 cad_att34
,att35 cad_att35
,att36 cad_att36
,att37 cad_att37
FROM svm4162
/

ANALYZE TABLE cad_att COMPUTE STATISTICS;

-- rpt 
SELECT COUNT(*)FROM svm4102;
SELECT COUNT(*)FROM cad_att;

--
-- chf410.sql
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
WHERE pair LIKE'%chf%'
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

DROP   TABLE chf_ms410 ;
CREATE TABLE chf_ms410 COMPRESS AS
SELECT
ydate
,trend chf_trend
,g4    chf_g4
,gatt  chf_gatt
,gattn chf_gattn
FROM modsrc
/

ANALYZE TABLE chf_ms410 COMPUTE STATISTICS;

-- I need a copy of the attributes:


DROP   TABLE chf_att;
CREATE TABLE chf_att COMPRESS AS
SELECT
ydate
,att00 chf_att00
,att01 chf_att01
,att02 chf_att02
,att03 chf_att03
,att04 chf_att04
,att05 chf_att05
,att06 chf_att06
,att07 chf_att07
,att08 chf_att08
,att09 chf_att09
,att10 chf_att10
,att11 chf_att11
,att12 chf_att12
,att13 chf_att13
,att14 chf_att14
,att15 chf_att15
,att16 chf_att16
,att17 chf_att17
,att18 chf_att18
,att19 chf_att19
,att20 chf_att20
,att21 chf_att21
,att22 chf_att22
,att23 chf_att23
,att24 chf_att24
,att25 chf_att25
,att26 chf_att26
,att27 chf_att27
,att28 chf_att28
,att29 chf_att29
,att30 chf_att30
,att31 chf_att31
,att32 chf_att32
,att33 chf_att33
,att34 chf_att34
,att35 chf_att35
,att36 chf_att36
,att37 chf_att37
FROM svm4162
/

ANALYZE TABLE chf_att COMPUTE STATISTICS;

-- rpt 
SELECT COUNT(*)FROM svm4102;
SELECT COUNT(*)FROM chf_att;

