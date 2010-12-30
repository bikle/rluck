--
-- eur610.sql
--

-- Creates views and tables for backtesting a forex SVM strategy

PURGE RECYCLEBIN;

-- I created di5min here:
-- /pt/s/rlk/svm8hp/update_di5min.sql

CREATE OR REPLACE VIEW svm6102 AS
SELECT
pair
,ydate
,prdate
,rownum rnum -- acts as t in my time-series
,clse
-- Derive a bunch of attributes from clse, the latest price:
,MIN(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*4 PRECEDING AND CURRENT ROW)min4
,MIN(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*6 PRECEDING AND CURRENT ROW)min6
,MIN(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*8 PRECEDING AND CURRENT ROW)min8
,MIN(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*10 PRECEDING AND CURRENT ROW)min10
,MIN(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*12 PRECEDING AND CURRENT ROW)min12
,MIN(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*14 PRECEDING AND CURRENT ROW)min14
,MIN(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*16 PRECEDING AND CURRENT ROW)min16
,MIN(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*18 PRECEDING AND CURRENT ROW)min18
--
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*4 PRECEDING AND CURRENT ROW)avg4
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*6 PRECEDING AND CURRENT ROW)avg6
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*8 PRECEDING AND CURRENT ROW)avg8
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*10 PRECEDING AND CURRENT ROW)avg10
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*12 PRECEDING AND CURRENT ROW)avg12
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*14 PRECEDING AND CURRENT ROW)avg14
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*16 PRECEDING AND CURRENT ROW)avg16
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*18 PRECEDING AND CURRENT ROW)avg18
--
,MAX(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*4 PRECEDING AND CURRENT ROW)max4
,MAX(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*6 PRECEDING AND CURRENT ROW)max6
,MAX(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*8 PRECEDING AND CURRENT ROW)max8
,MAX(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*10 PRECEDING AND CURRENT ROW)max10
,MAX(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*12 PRECEDING AND CURRENT ROW)max12
,MAX(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*14 PRECEDING AND CURRENT ROW)max14
,MAX(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*16 PRECEDING AND CURRENT ROW)max16
,MAX(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*18 PRECEDING AND CURRENT ROW)max18
,LEAD(clse,12*6,NULL)OVER(PARTITION BY pair ORDER BY ydate)ld6
FROM di5min WHERE pair LIKE'%eur%'
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
FROM svm6102
GROUP BY pair
/

-- Derive trend, clse-relations, moving correlation of clse, and date related params:
DROP TABLE svm6122;
CREATE TABLE svm6122 COMPRESS AS
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
,clse-min4  cm4  
,clse-min6  cm6  
,clse-min8  cm8  
,clse-min10 cm10 
,clse-min12 cm12 
,clse-min14 cm14 
,clse-min16 cm16 
,clse-min18 cm18 
-- clse relation to moving-avg
,clse-avg4  ca4  
,clse-avg6  ca6  
,clse-avg8  ca8  
,clse-avg10 ca10 
,clse-avg12 ca12 
,clse-avg14 ca14 
,clse-avg16 ca16 
,clse-avg18 ca18 
-- clse relation to moving-max
,clse-max4  cx4  
,clse-max6  cx6  
,clse-max8  cx8  
,clse-max10 cx10 
,clse-max12 cx12 
,clse-max14 cx14 
,clse-max16 cx16 
,clse-max18 cx18 
-- Derive more attributes.
-- I want to use CORR() here to help SVM see the shape of the series.
-- But COVAR_POP is more stable:
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*4  PRECEDING AND CURRENT ROW)crr4 
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*6  PRECEDING AND CURRENT ROW)crr6 
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*8  PRECEDING AND CURRENT ROW)crr8 
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*10 PRECEDING AND CURRENT ROW)crr10
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*12 PRECEDING AND CURRENT ROW)crr12
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*14 PRECEDING AND CURRENT ROW)crr14
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*16 PRECEDING AND CURRENT ROW)crr16
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*18 PRECEDING AND CURRENT ROW)crr18
-- Derive date related attributes:
,0+TO_CHAR( ROUND(ydate,'HH24'),'HH24')hh
,0+TO_CHAR(ydate,'D')d
,0+TO_CHAR(ydate,'W')w
-- mpm stands for minutes-past-midnight:
,ROUND( (ydate - trunc(ydate))*24*60 )mpm
-- mph stands for minutes-past-hour:
,0+TO_CHAR(ydate,'MI')mph
FROM svm6102
ORDER BY ydate
/

-- rpt

SELECT
pair
,COUNT(pair)
,MIN(clse),MAX(clse)
,MIN(ydate),MAX(ydate)
FROM svm6122
GROUP BY pair
/

-- Prepare for derivation of NTILE based params:

DROP TABLE svm6142;
CREATE TABLE svm6142 COMPRESS AS
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
,cm4  
,cm6  
,cm8  
,cm10 
,cm12 
,cm14 
,cm16 
,cm18 
-- 
,ca4  
,ca6  
,ca8  
,ca10 
,ca12 
,ca14 
,ca16 
,ca18 
--
,cx4  
,cx6  
,cx8  
,cx10 
,cx12 
,cx14 
,cx16 
,cx18 
--
,crr4 
,crr6 
,crr8 
,crr10
,crr12
,crr14
,crr16
,crr18
--
,hh
,d
,w
,mpm
,mph
FROM svm6122
ORDER BY ydate
/

-- rpt

SELECT
pair
,trend
,gatt
,COUNT(pair)
,AVG(g6)
FROM svm6142
GROUP BY pair,trend,gatt
ORDER BY pair,trend,gatt
/


-- Derive NTILE based params:

DROP TABLE svm6162;
CREATE TABLE svm6162 COMPRESS AS
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
FROM svm6142
ORDER BY ydate
/

-- rpt

SELECT
pair
,trend
,gatt
,COUNT(pair)
,AVG(g6)
FROM svm6162
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
FROM svm6162
/

ANALYZE TABLE modsrc COMPUTE STATISTICS;

DROP   TABLE eur_ms610 ;
CREATE TABLE eur_ms610 COMPRESS AS
SELECT
ydate
,trend eur_trend
,g6    eur_g6
,gatt  eur_gatt
,gattn eur_gattn
FROM modsrc
/

ANALYZE TABLE eur_ms610 COMPUTE STATISTICS;

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
FROM svm6162
/

ANALYZE TABLE eur_att COMPUTE STATISTICS;

-- rpt 
SELECT COUNT(*)FROM svm6102;
SELECT COUNT(*)FROM eur_att;

--
-- aud610.sql
--

-- Creates views and tables for backtesting a forex SVM strategy

PURGE RECYCLEBIN;

-- I created di5min here:
-- /pt/s/rlk/svm8hp/update_di5min.sql

CREATE OR REPLACE VIEW svm6102 AS
SELECT
pair
,ydate
,prdate
,rownum rnum -- acts as t in my time-series
,clse
-- Derive a bunch of attributes from clse, the latest price:
,MIN(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*4 PRECEDING AND CURRENT ROW)min4
,MIN(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*6 PRECEDING AND CURRENT ROW)min6
,MIN(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*8 PRECEDING AND CURRENT ROW)min8
,MIN(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*10 PRECEDING AND CURRENT ROW)min10
,MIN(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*12 PRECEDING AND CURRENT ROW)min12
,MIN(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*14 PRECEDING AND CURRENT ROW)min14
,MIN(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*16 PRECEDING AND CURRENT ROW)min16
,MIN(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*18 PRECEDING AND CURRENT ROW)min18
--
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*4 PRECEDING AND CURRENT ROW)avg4
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*6 PRECEDING AND CURRENT ROW)avg6
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*8 PRECEDING AND CURRENT ROW)avg8
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*10 PRECEDING AND CURRENT ROW)avg10
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*12 PRECEDING AND CURRENT ROW)avg12
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*14 PRECEDING AND CURRENT ROW)avg14
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*16 PRECEDING AND CURRENT ROW)avg16
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*18 PRECEDING AND CURRENT ROW)avg18
--
,MAX(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*4 PRECEDING AND CURRENT ROW)max4
,MAX(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*6 PRECEDING AND CURRENT ROW)max6
,MAX(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*8 PRECEDING AND CURRENT ROW)max8
,MAX(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*10 PRECEDING AND CURRENT ROW)max10
,MAX(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*12 PRECEDING AND CURRENT ROW)max12
,MAX(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*14 PRECEDING AND CURRENT ROW)max14
,MAX(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*16 PRECEDING AND CURRENT ROW)max16
,MAX(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*18 PRECEDING AND CURRENT ROW)max18
,LEAD(clse,12*6,NULL)OVER(PARTITION BY pair ORDER BY ydate)ld6
FROM di5min WHERE pair LIKE'%aud%'
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
FROM svm6102
GROUP BY pair
/

-- Derive trend, clse-relations, moving correlation of clse, and date related params:
DROP TABLE svm6122;
CREATE TABLE svm6122 COMPRESS AS
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
,clse-min4  cm4  
,clse-min6  cm6  
,clse-min8  cm8  
,clse-min10 cm10 
,clse-min12 cm12 
,clse-min14 cm14 
,clse-min16 cm16 
,clse-min18 cm18 
-- clse relation to moving-avg
,clse-avg4  ca4  
,clse-avg6  ca6  
,clse-avg8  ca8  
,clse-avg10 ca10 
,clse-avg12 ca12 
,clse-avg14 ca14 
,clse-avg16 ca16 
,clse-avg18 ca18 
-- clse relation to moving-max
,clse-max4  cx4  
,clse-max6  cx6  
,clse-max8  cx8  
,clse-max10 cx10 
,clse-max12 cx12 
,clse-max14 cx14 
,clse-max16 cx16 
,clse-max18 cx18 
-- Derive more attributes.
-- I want to use CORR() here to help SVM see the shape of the series.
-- But COVAR_POP is more stable:
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*4  PRECEDING AND CURRENT ROW)crr4 
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*6  PRECEDING AND CURRENT ROW)crr6 
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*8  PRECEDING AND CURRENT ROW)crr8 
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*10 PRECEDING AND CURRENT ROW)crr10
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*12 PRECEDING AND CURRENT ROW)crr12
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*14 PRECEDING AND CURRENT ROW)crr14
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*16 PRECEDING AND CURRENT ROW)crr16
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*18 PRECEDING AND CURRENT ROW)crr18
-- Derive date related attributes:
,0+TO_CHAR( ROUND(ydate,'HH24'),'HH24')hh
,0+TO_CHAR(ydate,'D')d
,0+TO_CHAR(ydate,'W')w
-- mpm stands for minutes-past-midnight:
,ROUND( (ydate - trunc(ydate))*24*60 )mpm
-- mph stands for minutes-past-hour:
,0+TO_CHAR(ydate,'MI')mph
FROM svm6102
ORDER BY ydate
/

-- rpt

SELECT
pair
,COUNT(pair)
,MIN(clse),MAX(clse)
,MIN(ydate),MAX(ydate)
FROM svm6122
GROUP BY pair
/

-- Prepare for derivation of NTILE based params:

DROP TABLE svm6142;
CREATE TABLE svm6142 COMPRESS AS
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
,cm4  
,cm6  
,cm8  
,cm10 
,cm12 
,cm14 
,cm16 
,cm18 
-- 
,ca4  
,ca6  
,ca8  
,ca10 
,ca12 
,ca14 
,ca16 
,ca18 
--
,cx4  
,cx6  
,cx8  
,cx10 
,cx12 
,cx14 
,cx16 
,cx18 
--
,crr4 
,crr6 
,crr8 
,crr10
,crr12
,crr14
,crr16
,crr18
--
,hh
,d
,w
,mpm
,mph
FROM svm6122
ORDER BY ydate
/

-- rpt

SELECT
pair
,trend
,gatt
,COUNT(pair)
,AVG(g6)
FROM svm6142
GROUP BY pair,trend,gatt
ORDER BY pair,trend,gatt
/


-- Derive NTILE based params:

DROP TABLE svm6162;
CREATE TABLE svm6162 COMPRESS AS
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
FROM svm6142
ORDER BY ydate
/

-- rpt

SELECT
pair
,trend
,gatt
,COUNT(pair)
,AVG(g6)
FROM svm6162
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
FROM svm6162
/

ANALYZE TABLE modsrc COMPUTE STATISTICS;

DROP   TABLE aud_ms610 ;
CREATE TABLE aud_ms610 COMPRESS AS
SELECT
ydate
,trend aud_trend
,g6    aud_g6
,gatt  aud_gatt
,gattn aud_gattn
FROM modsrc
/

ANALYZE TABLE aud_ms610 COMPUTE STATISTICS;

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
FROM svm6162
/

ANALYZE TABLE aud_att COMPUTE STATISTICS;

-- rpt 
SELECT COUNT(*)FROM svm6102;
SELECT COUNT(*)FROM aud_att;

--
-- gbp610.sql
--

-- Creates views and tables for backtesting a forex SVM strategy

PURGE RECYCLEBIN;

-- I created di5min here:
-- /pt/s/rlk/svm8hp/update_di5min.sql

CREATE OR REPLACE VIEW svm6102 AS
SELECT
pair
,ydate
,prdate
,rownum rnum -- acts as t in my time-series
,clse
-- Derive a bunch of attributes from clse, the latest price:
,MIN(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*4 PRECEDING AND CURRENT ROW)min4
,MIN(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*6 PRECEDING AND CURRENT ROW)min6
,MIN(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*8 PRECEDING AND CURRENT ROW)min8
,MIN(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*10 PRECEDING AND CURRENT ROW)min10
,MIN(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*12 PRECEDING AND CURRENT ROW)min12
,MIN(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*14 PRECEDING AND CURRENT ROW)min14
,MIN(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*16 PRECEDING AND CURRENT ROW)min16
,MIN(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*18 PRECEDING AND CURRENT ROW)min18
--
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*4 PRECEDING AND CURRENT ROW)avg4
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*6 PRECEDING AND CURRENT ROW)avg6
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*8 PRECEDING AND CURRENT ROW)avg8
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*10 PRECEDING AND CURRENT ROW)avg10
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*12 PRECEDING AND CURRENT ROW)avg12
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*14 PRECEDING AND CURRENT ROW)avg14
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*16 PRECEDING AND CURRENT ROW)avg16
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*18 PRECEDING AND CURRENT ROW)avg18
--
,MAX(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*4 PRECEDING AND CURRENT ROW)max4
,MAX(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*6 PRECEDING AND CURRENT ROW)max6
,MAX(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*8 PRECEDING AND CURRENT ROW)max8
,MAX(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*10 PRECEDING AND CURRENT ROW)max10
,MAX(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*12 PRECEDING AND CURRENT ROW)max12
,MAX(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*14 PRECEDING AND CURRENT ROW)max14
,MAX(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*16 PRECEDING AND CURRENT ROW)max16
,MAX(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*18 PRECEDING AND CURRENT ROW)max18
,LEAD(clse,12*6,NULL)OVER(PARTITION BY pair ORDER BY ydate)ld6
FROM di5min WHERE pair LIKE'%gbp%'
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
FROM svm6102
GROUP BY pair
/

-- Derive trend, clse-relations, moving correlation of clse, and date related params:
DROP TABLE svm6122;
CREATE TABLE svm6122 COMPRESS AS
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
,clse-min4  cm4  
,clse-min6  cm6  
,clse-min8  cm8  
,clse-min10 cm10 
,clse-min12 cm12 
,clse-min14 cm14 
,clse-min16 cm16 
,clse-min18 cm18 
-- clse relation to moving-avg
,clse-avg4  ca4  
,clse-avg6  ca6  
,clse-avg8  ca8  
,clse-avg10 ca10 
,clse-avg12 ca12 
,clse-avg14 ca14 
,clse-avg16 ca16 
,clse-avg18 ca18 
-- clse relation to moving-max
,clse-max4  cx4  
,clse-max6  cx6  
,clse-max8  cx8  
,clse-max10 cx10 
,clse-max12 cx12 
,clse-max14 cx14 
,clse-max16 cx16 
,clse-max18 cx18 
-- Derive more attributes.
-- I want to use CORR() here to help SVM see the shape of the series.
-- But COVAR_POP is more stable:
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*4  PRECEDING AND CURRENT ROW)crr4 
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*6  PRECEDING AND CURRENT ROW)crr6 
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*8  PRECEDING AND CURRENT ROW)crr8 
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*10 PRECEDING AND CURRENT ROW)crr10
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*12 PRECEDING AND CURRENT ROW)crr12
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*14 PRECEDING AND CURRENT ROW)crr14
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*16 PRECEDING AND CURRENT ROW)crr16
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*18 PRECEDING AND CURRENT ROW)crr18
-- Derive date related attributes:
,0+TO_CHAR( ROUND(ydate,'HH24'),'HH24')hh
,0+TO_CHAR(ydate,'D')d
,0+TO_CHAR(ydate,'W')w
-- mpm stands for minutes-past-midnight:
,ROUND( (ydate - trunc(ydate))*24*60 )mpm
-- mph stands for minutes-past-hour:
,0+TO_CHAR(ydate,'MI')mph
FROM svm6102
ORDER BY ydate
/

-- rpt

SELECT
pair
,COUNT(pair)
,MIN(clse),MAX(clse)
,MIN(ydate),MAX(ydate)
FROM svm6122
GROUP BY pair
/

-- Prepare for derivation of NTILE based params:

DROP TABLE svm6142;
CREATE TABLE svm6142 COMPRESS AS
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
,cm4  
,cm6  
,cm8  
,cm10 
,cm12 
,cm14 
,cm16 
,cm18 
-- 
,ca4  
,ca6  
,ca8  
,ca10 
,ca12 
,ca14 
,ca16 
,ca18 
--
,cx4  
,cx6  
,cx8  
,cx10 
,cx12 
,cx14 
,cx16 
,cx18 
--
,crr4 
,crr6 
,crr8 
,crr10
,crr12
,crr14
,crr16
,crr18
--
,hh
,d
,w
,mpm
,mph
FROM svm6122
ORDER BY ydate
/

-- rpt

SELECT
pair
,trend
,gatt
,COUNT(pair)
,AVG(g6)
FROM svm6142
GROUP BY pair,trend,gatt
ORDER BY pair,trend,gatt
/


-- Derive NTILE based params:

DROP TABLE svm6162;
CREATE TABLE svm6162 COMPRESS AS
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
FROM svm6142
ORDER BY ydate
/

-- rpt

SELECT
pair
,trend
,gatt
,COUNT(pair)
,AVG(g6)
FROM svm6162
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
FROM svm6162
/

ANALYZE TABLE modsrc COMPUTE STATISTICS;

DROP   TABLE gbp_ms610 ;
CREATE TABLE gbp_ms610 COMPRESS AS
SELECT
ydate
,trend gbp_trend
,g6    gbp_g6
,gatt  gbp_gatt
,gattn gbp_gattn
FROM modsrc
/

ANALYZE TABLE gbp_ms610 COMPUTE STATISTICS;

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
FROM svm6162
/

ANALYZE TABLE gbp_att COMPUTE STATISTICS;

-- rpt 
SELECT COUNT(*)FROM svm6102;
SELECT COUNT(*)FROM gbp_att;

--
-- jpy610.sql
--

-- Creates views and tables for backtesting a forex SVM strategy

PURGE RECYCLEBIN;

-- I created di5min here:
-- /pt/s/rlk/svm8hp/update_di5min.sql

CREATE OR REPLACE VIEW svm6102 AS
SELECT
pair
,ydate
,prdate
,rownum rnum -- acts as t in my time-series
,clse
-- Derive a bunch of attributes from clse, the latest price:
,MIN(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*4 PRECEDING AND CURRENT ROW)min4
,MIN(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*6 PRECEDING AND CURRENT ROW)min6
,MIN(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*8 PRECEDING AND CURRENT ROW)min8
,MIN(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*10 PRECEDING AND CURRENT ROW)min10
,MIN(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*12 PRECEDING AND CURRENT ROW)min12
,MIN(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*14 PRECEDING AND CURRENT ROW)min14
,MIN(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*16 PRECEDING AND CURRENT ROW)min16
,MIN(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*18 PRECEDING AND CURRENT ROW)min18
--
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*4 PRECEDING AND CURRENT ROW)avg4
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*6 PRECEDING AND CURRENT ROW)avg6
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*8 PRECEDING AND CURRENT ROW)avg8
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*10 PRECEDING AND CURRENT ROW)avg10
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*12 PRECEDING AND CURRENT ROW)avg12
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*14 PRECEDING AND CURRENT ROW)avg14
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*16 PRECEDING AND CURRENT ROW)avg16
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*18 PRECEDING AND CURRENT ROW)avg18
--
,MAX(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*4 PRECEDING AND CURRENT ROW)max4
,MAX(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*6 PRECEDING AND CURRENT ROW)max6
,MAX(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*8 PRECEDING AND CURRENT ROW)max8
,MAX(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*10 PRECEDING AND CURRENT ROW)max10
,MAX(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*12 PRECEDING AND CURRENT ROW)max12
,MAX(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*14 PRECEDING AND CURRENT ROW)max14
,MAX(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*16 PRECEDING AND CURRENT ROW)max16
,MAX(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*18 PRECEDING AND CURRENT ROW)max18
,LEAD(clse,12*6,NULL)OVER(PARTITION BY pair ORDER BY ydate)ld6
FROM di5min WHERE pair LIKE'%jpy%'
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
FROM svm6102
GROUP BY pair
/

-- Derive trend, clse-relations, moving correlation of clse, and date related params:
DROP TABLE svm6122;
CREATE TABLE svm6122 COMPRESS AS
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
,clse-min4  cm4  
,clse-min6  cm6  
,clse-min8  cm8  
,clse-min10 cm10 
,clse-min12 cm12 
,clse-min14 cm14 
,clse-min16 cm16 
,clse-min18 cm18 
-- clse relation to moving-avg
,clse-avg4  ca4  
,clse-avg6  ca6  
,clse-avg8  ca8  
,clse-avg10 ca10 
,clse-avg12 ca12 
,clse-avg14 ca14 
,clse-avg16 ca16 
,clse-avg18 ca18 
-- clse relation to moving-max
,clse-max4  cx4  
,clse-max6  cx6  
,clse-max8  cx8  
,clse-max10 cx10 
,clse-max12 cx12 
,clse-max14 cx14 
,clse-max16 cx16 
,clse-max18 cx18 
-- Derive more attributes.
-- I want to use CORR() here to help SVM see the shape of the series.
-- But COVAR_POP is more stable:
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*4  PRECEDING AND CURRENT ROW)crr4 
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*6  PRECEDING AND CURRENT ROW)crr6 
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*8  PRECEDING AND CURRENT ROW)crr8 
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*10 PRECEDING AND CURRENT ROW)crr10
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*12 PRECEDING AND CURRENT ROW)crr12
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*14 PRECEDING AND CURRENT ROW)crr14
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*16 PRECEDING AND CURRENT ROW)crr16
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*18 PRECEDING AND CURRENT ROW)crr18
-- Derive date related attributes:
,0+TO_CHAR( ROUND(ydate,'HH24'),'HH24')hh
,0+TO_CHAR(ydate,'D')d
,0+TO_CHAR(ydate,'W')w
-- mpm stands for minutes-past-midnight:
,ROUND( (ydate - trunc(ydate))*24*60 )mpm
-- mph stands for minutes-past-hour:
,0+TO_CHAR(ydate,'MI')mph
FROM svm6102
ORDER BY ydate
/

-- rpt

SELECT
pair
,COUNT(pair)
,MIN(clse),MAX(clse)
,MIN(ydate),MAX(ydate)
FROM svm6122
GROUP BY pair
/

-- Prepare for derivation of NTILE based params:

DROP TABLE svm6142;
CREATE TABLE svm6142 COMPRESS AS
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
,cm4  
,cm6  
,cm8  
,cm10 
,cm12 
,cm14 
,cm16 
,cm18 
-- 
,ca4  
,ca6  
,ca8  
,ca10 
,ca12 
,ca14 
,ca16 
,ca18 
--
,cx4  
,cx6  
,cx8  
,cx10 
,cx12 
,cx14 
,cx16 
,cx18 
--
,crr4 
,crr6 
,crr8 
,crr10
,crr12
,crr14
,crr16
,crr18
--
,hh
,d
,w
,mpm
,mph
FROM svm6122
ORDER BY ydate
/

-- rpt

SELECT
pair
,trend
,gatt
,COUNT(pair)
,AVG(g6)
FROM svm6142
GROUP BY pair,trend,gatt
ORDER BY pair,trend,gatt
/


-- Derive NTILE based params:

DROP TABLE svm6162;
CREATE TABLE svm6162 COMPRESS AS
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
FROM svm6142
ORDER BY ydate
/

-- rpt

SELECT
pair
,trend
,gatt
,COUNT(pair)
,AVG(g6)
FROM svm6162
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
FROM svm6162
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
FROM svm6162
/

ANALYZE TABLE jpy_att COMPUTE STATISTICS;

-- rpt 
SELECT COUNT(*)FROM svm6102;
SELECT COUNT(*)FROM jpy_att;

--
-- cad610.sql
--

-- Creates views and tables for backtesting a forex SVM strategy

PURGE RECYCLEBIN;

-- I created di5min here:
-- /pt/s/rlk/svm8hp/update_di5min.sql

CREATE OR REPLACE VIEW svm6102 AS
SELECT
pair
,ydate
,prdate
,rownum rnum -- acts as t in my time-series
,clse
-- Derive a bunch of attributes from clse, the latest price:
,MIN(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*4 PRECEDING AND CURRENT ROW)min4
,MIN(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*6 PRECEDING AND CURRENT ROW)min6
,MIN(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*8 PRECEDING AND CURRENT ROW)min8
,MIN(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*10 PRECEDING AND CURRENT ROW)min10
,MIN(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*12 PRECEDING AND CURRENT ROW)min12
,MIN(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*14 PRECEDING AND CURRENT ROW)min14
,MIN(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*16 PRECEDING AND CURRENT ROW)min16
,MIN(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*18 PRECEDING AND CURRENT ROW)min18
--
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*4 PRECEDING AND CURRENT ROW)avg4
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*6 PRECEDING AND CURRENT ROW)avg6
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*8 PRECEDING AND CURRENT ROW)avg8
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*10 PRECEDING AND CURRENT ROW)avg10
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*12 PRECEDING AND CURRENT ROW)avg12
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*14 PRECEDING AND CURRENT ROW)avg14
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*16 PRECEDING AND CURRENT ROW)avg16
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*18 PRECEDING AND CURRENT ROW)avg18
--
,MAX(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*4 PRECEDING AND CURRENT ROW)max4
,MAX(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*6 PRECEDING AND CURRENT ROW)max6
,MAX(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*8 PRECEDING AND CURRENT ROW)max8
,MAX(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*10 PRECEDING AND CURRENT ROW)max10
,MAX(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*12 PRECEDING AND CURRENT ROW)max12
,MAX(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*14 PRECEDING AND CURRENT ROW)max14
,MAX(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*16 PRECEDING AND CURRENT ROW)max16
,MAX(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*18 PRECEDING AND CURRENT ROW)max18
,LEAD(clse,12*6,NULL)OVER(PARTITION BY pair ORDER BY ydate)ld6
FROM di5min WHERE pair LIKE'%cad%'
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
FROM svm6102
GROUP BY pair
/

-- Derive trend, clse-relations, moving correlation of clse, and date related params:
DROP TABLE svm6122;
CREATE TABLE svm6122 COMPRESS AS
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
,clse-min4  cm4  
,clse-min6  cm6  
,clse-min8  cm8  
,clse-min10 cm10 
,clse-min12 cm12 
,clse-min14 cm14 
,clse-min16 cm16 
,clse-min18 cm18 
-- clse relation to moving-avg
,clse-avg4  ca4  
,clse-avg6  ca6  
,clse-avg8  ca8  
,clse-avg10 ca10 
,clse-avg12 ca12 
,clse-avg14 ca14 
,clse-avg16 ca16 
,clse-avg18 ca18 
-- clse relation to moving-max
,clse-max4  cx4  
,clse-max6  cx6  
,clse-max8  cx8  
,clse-max10 cx10 
,clse-max12 cx12 
,clse-max14 cx14 
,clse-max16 cx16 
,clse-max18 cx18 
-- Derive more attributes.
-- I want to use CORR() here to help SVM see the shape of the series.
-- But COVAR_POP is more stable:
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*4  PRECEDING AND CURRENT ROW)crr4 
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*6  PRECEDING AND CURRENT ROW)crr6 
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*8  PRECEDING AND CURRENT ROW)crr8 
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*10 PRECEDING AND CURRENT ROW)crr10
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*12 PRECEDING AND CURRENT ROW)crr12
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*14 PRECEDING AND CURRENT ROW)crr14
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*16 PRECEDING AND CURRENT ROW)crr16
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*18 PRECEDING AND CURRENT ROW)crr18
-- Derive date related attributes:
,0+TO_CHAR( ROUND(ydate,'HH24'),'HH24')hh
,0+TO_CHAR(ydate,'D')d
,0+TO_CHAR(ydate,'W')w
-- mpm stands for minutes-past-midnight:
,ROUND( (ydate - trunc(ydate))*24*60 )mpm
-- mph stands for minutes-past-hour:
,0+TO_CHAR(ydate,'MI')mph
FROM svm6102
ORDER BY ydate
/

-- rpt

SELECT
pair
,COUNT(pair)
,MIN(clse),MAX(clse)
,MIN(ydate),MAX(ydate)
FROM svm6122
GROUP BY pair
/

-- Prepare for derivation of NTILE based params:

DROP TABLE svm6142;
CREATE TABLE svm6142 COMPRESS AS
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
,cm4  
,cm6  
,cm8  
,cm10 
,cm12 
,cm14 
,cm16 
,cm18 
-- 
,ca4  
,ca6  
,ca8  
,ca10 
,ca12 
,ca14 
,ca16 
,ca18 
--
,cx4  
,cx6  
,cx8  
,cx10 
,cx12 
,cx14 
,cx16 
,cx18 
--
,crr4 
,crr6 
,crr8 
,crr10
,crr12
,crr14
,crr16
,crr18
--
,hh
,d
,w
,mpm
,mph
FROM svm6122
ORDER BY ydate
/

-- rpt

SELECT
pair
,trend
,gatt
,COUNT(pair)
,AVG(g6)
FROM svm6142
GROUP BY pair,trend,gatt
ORDER BY pair,trend,gatt
/


-- Derive NTILE based params:

DROP TABLE svm6162;
CREATE TABLE svm6162 COMPRESS AS
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
FROM svm6142
ORDER BY ydate
/

-- rpt

SELECT
pair
,trend
,gatt
,COUNT(pair)
,AVG(g6)
FROM svm6162
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
FROM svm6162
/

ANALYZE TABLE modsrc COMPUTE STATISTICS;

DROP   TABLE cad_ms610 ;
CREATE TABLE cad_ms610 COMPRESS AS
SELECT
ydate
,trend cad_trend
,g6    cad_g6
,gatt  cad_gatt
,gattn cad_gattn
FROM modsrc
/

ANALYZE TABLE cad_ms610 COMPUTE STATISTICS;

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
FROM svm6162
/

ANALYZE TABLE cad_att COMPUTE STATISTICS;

-- rpt 
SELECT COUNT(*)FROM svm6102;
SELECT COUNT(*)FROM cad_att;

--
-- chf610.sql
--

-- Creates views and tables for backtesting a forex SVM strategy

PURGE RECYCLEBIN;

-- I created di5min here:
-- /pt/s/rlk/svm8hp/update_di5min.sql

CREATE OR REPLACE VIEW svm6102 AS
SELECT
pair
,ydate
,prdate
,rownum rnum -- acts as t in my time-series
,clse
-- Derive a bunch of attributes from clse, the latest price:
,MIN(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*4 PRECEDING AND CURRENT ROW)min4
,MIN(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*6 PRECEDING AND CURRENT ROW)min6
,MIN(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*8 PRECEDING AND CURRENT ROW)min8
,MIN(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*10 PRECEDING AND CURRENT ROW)min10
,MIN(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*12 PRECEDING AND CURRENT ROW)min12
,MIN(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*14 PRECEDING AND CURRENT ROW)min14
,MIN(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*16 PRECEDING AND CURRENT ROW)min16
,MIN(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*18 PRECEDING AND CURRENT ROW)min18
--
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*4 PRECEDING AND CURRENT ROW)avg4
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*6 PRECEDING AND CURRENT ROW)avg6
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*8 PRECEDING AND CURRENT ROW)avg8
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*10 PRECEDING AND CURRENT ROW)avg10
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*12 PRECEDING AND CURRENT ROW)avg12
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*14 PRECEDING AND CURRENT ROW)avg14
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*16 PRECEDING AND CURRENT ROW)avg16
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*18 PRECEDING AND CURRENT ROW)avg18
--
,MAX(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*4 PRECEDING AND CURRENT ROW)max4
,MAX(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*6 PRECEDING AND CURRENT ROW)max6
,MAX(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*8 PRECEDING AND CURRENT ROW)max8
,MAX(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*10 PRECEDING AND CURRENT ROW)max10
,MAX(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*12 PRECEDING AND CURRENT ROW)max12
,MAX(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*14 PRECEDING AND CURRENT ROW)max14
,MAX(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*16 PRECEDING AND CURRENT ROW)max16
,MAX(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*18 PRECEDING AND CURRENT ROW)max18
,LEAD(clse,12*6,NULL)OVER(PARTITION BY pair ORDER BY ydate)ld6
FROM di5min WHERE pair LIKE'%chf%'
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
FROM svm6102
GROUP BY pair
/

-- Derive trend, clse-relations, moving correlation of clse, and date related params:
DROP TABLE svm6122;
CREATE TABLE svm6122 COMPRESS AS
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
,clse-min4  cm4  
,clse-min6  cm6  
,clse-min8  cm8  
,clse-min10 cm10 
,clse-min12 cm12 
,clse-min14 cm14 
,clse-min16 cm16 
,clse-min18 cm18 
-- clse relation to moving-avg
,clse-avg4  ca4  
,clse-avg6  ca6  
,clse-avg8  ca8  
,clse-avg10 ca10 
,clse-avg12 ca12 
,clse-avg14 ca14 
,clse-avg16 ca16 
,clse-avg18 ca18 
-- clse relation to moving-max
,clse-max4  cx4  
,clse-max6  cx6  
,clse-max8  cx8  
,clse-max10 cx10 
,clse-max12 cx12 
,clse-max14 cx14 
,clse-max16 cx16 
,clse-max18 cx18 
-- Derive more attributes.
-- I want to use CORR() here to help SVM see the shape of the series.
-- But COVAR_POP is more stable:
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*4  PRECEDING AND CURRENT ROW)crr4 
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*6  PRECEDING AND CURRENT ROW)crr6 
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*8  PRECEDING AND CURRENT ROW)crr8 
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*10 PRECEDING AND CURRENT ROW)crr10
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*12 PRECEDING AND CURRENT ROW)crr12
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*14 PRECEDING AND CURRENT ROW)crr14
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*16 PRECEDING AND CURRENT ROW)crr16
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*18 PRECEDING AND CURRENT ROW)crr18
-- Derive date related attributes:
,0+TO_CHAR( ROUND(ydate,'HH24'),'HH24')hh
,0+TO_CHAR(ydate,'D')d
,0+TO_CHAR(ydate,'W')w
-- mpm stands for minutes-past-midnight:
,ROUND( (ydate - trunc(ydate))*24*60 )mpm
-- mph stands for minutes-past-hour:
,0+TO_CHAR(ydate,'MI')mph
FROM svm6102
ORDER BY ydate
/

-- rpt

SELECT
pair
,COUNT(pair)
,MIN(clse),MAX(clse)
,MIN(ydate),MAX(ydate)
FROM svm6122
GROUP BY pair
/

-- Prepare for derivation of NTILE based params:

DROP TABLE svm6142;
CREATE TABLE svm6142 COMPRESS AS
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
,cm4  
,cm6  
,cm8  
,cm10 
,cm12 
,cm14 
,cm16 
,cm18 
-- 
,ca4  
,ca6  
,ca8  
,ca10 
,ca12 
,ca14 
,ca16 
,ca18 
--
,cx4  
,cx6  
,cx8  
,cx10 
,cx12 
,cx14 
,cx16 
,cx18 
--
,crr4 
,crr6 
,crr8 
,crr10
,crr12
,crr14
,crr16
,crr18
--
,hh
,d
,w
,mpm
,mph
FROM svm6122
ORDER BY ydate
/

-- rpt

SELECT
pair
,trend
,gatt
,COUNT(pair)
,AVG(g6)
FROM svm6142
GROUP BY pair,trend,gatt
ORDER BY pair,trend,gatt
/


-- Derive NTILE based params:

DROP TABLE svm6162;
CREATE TABLE svm6162 COMPRESS AS
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
FROM svm6142
ORDER BY ydate
/

-- rpt

SELECT
pair
,trend
,gatt
,COUNT(pair)
,AVG(g6)
FROM svm6162
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
FROM svm6162
/

ANALYZE TABLE modsrc COMPUTE STATISTICS;

DROP   TABLE chf_ms610 ;
CREATE TABLE chf_ms610 COMPRESS AS
SELECT
ydate
,trend chf_trend
,g6    chf_g6
,gatt  chf_gatt
,gattn chf_gattn
FROM modsrc
/

ANALYZE TABLE chf_ms610 COMPUTE STATISTICS;

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
FROM svm6162
/

ANALYZE TABLE chf_att COMPUTE STATISTICS;

-- rpt 
SELECT COUNT(*)FROM svm6102;
SELECT COUNT(*)FROM chf_att;

--
-- ech610.sql
--

-- Creates views and tables for backtesting a forex SVM strategy

PURGE RECYCLEBIN;

-- I created di5min here:
-- /pt/s/rlk/svm8hp/update_di5min.sql

CREATE OR REPLACE VIEW svm6102 AS
SELECT
pair
,ydate
,prdate
,rownum rnum -- acts as t in my time-series
,clse
-- Derive a bunch of attributes from clse, the latest price:
,MIN(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*4 PRECEDING AND CURRENT ROW)min4
,MIN(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*6 PRECEDING AND CURRENT ROW)min6
,MIN(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*8 PRECEDING AND CURRENT ROW)min8
,MIN(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*10 PRECEDING AND CURRENT ROW)min10
,MIN(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*12 PRECEDING AND CURRENT ROW)min12
,MIN(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*14 PRECEDING AND CURRENT ROW)min14
,MIN(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*16 PRECEDING AND CURRENT ROW)min16
,MIN(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*18 PRECEDING AND CURRENT ROW)min18
--
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*4 PRECEDING AND CURRENT ROW)avg4
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*6 PRECEDING AND CURRENT ROW)avg6
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*8 PRECEDING AND CURRENT ROW)avg8
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*10 PRECEDING AND CURRENT ROW)avg10
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*12 PRECEDING AND CURRENT ROW)avg12
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*14 PRECEDING AND CURRENT ROW)avg14
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*16 PRECEDING AND CURRENT ROW)avg16
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*18 PRECEDING AND CURRENT ROW)avg18
--
,MAX(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*4 PRECEDING AND CURRENT ROW)max4
,MAX(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*6 PRECEDING AND CURRENT ROW)max6
,MAX(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*8 PRECEDING AND CURRENT ROW)max8
,MAX(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*10 PRECEDING AND CURRENT ROW)max10
,MAX(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*12 PRECEDING AND CURRENT ROW)max12
,MAX(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*14 PRECEDING AND CURRENT ROW)max14
,MAX(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*16 PRECEDING AND CURRENT ROW)max16
,MAX(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*18 PRECEDING AND CURRENT ROW)max18
,LEAD(clse,12*6,NULL)OVER(PARTITION BY pair ORDER BY ydate)ld6
FROM di5min WHERE pair LIKE'%ech%'
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
FROM svm6102
GROUP BY pair
/

-- Derive trend, clse-relations, moving correlation of clse, and date related params:
DROP TABLE svm6122;
CREATE TABLE svm6122 COMPRESS AS
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
,clse-min4  cm4  
,clse-min6  cm6  
,clse-min8  cm8  
,clse-min10 cm10 
,clse-min12 cm12 
,clse-min14 cm14 
,clse-min16 cm16 
,clse-min18 cm18 
-- clse relation to moving-avg
,clse-avg4  ca4  
,clse-avg6  ca6  
,clse-avg8  ca8  
,clse-avg10 ca10 
,clse-avg12 ca12 
,clse-avg14 ca14 
,clse-avg16 ca16 
,clse-avg18 ca18 
-- clse relation to moving-max
,clse-max4  cx4  
,clse-max6  cx6  
,clse-max8  cx8  
,clse-max10 cx10 
,clse-max12 cx12 
,clse-max14 cx14 
,clse-max16 cx16 
,clse-max18 cx18 
-- Derive more attributes.
-- I want to use CORR() here to help SVM see the shape of the series.
-- But COVAR_POP is more stable:
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*4  PRECEDING AND CURRENT ROW)crr4 
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*6  PRECEDING AND CURRENT ROW)crr6 
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*8  PRECEDING AND CURRENT ROW)crr8 
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*10 PRECEDING AND CURRENT ROW)crr10
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*12 PRECEDING AND CURRENT ROW)crr12
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*14 PRECEDING AND CURRENT ROW)crr14
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*16 PRECEDING AND CURRENT ROW)crr16
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*18 PRECEDING AND CURRENT ROW)crr18
-- Derive date related attributes:
,0+TO_CHAR( ROUND(ydate,'HH24'),'HH24')hh
,0+TO_CHAR(ydate,'D')d
,0+TO_CHAR(ydate,'W')w
-- mpm stands for minutes-past-midnight:
,ROUND( (ydate - trunc(ydate))*24*60 )mpm
-- mph stands for minutes-past-hour:
,0+TO_CHAR(ydate,'MI')mph
FROM svm6102
ORDER BY ydate
/

-- rpt

SELECT
pair
,COUNT(pair)
,MIN(clse),MAX(clse)
,MIN(ydate),MAX(ydate)
FROM svm6122
GROUP BY pair
/

-- Prepare for derivation of NTILE based params:

DROP TABLE svm6142;
CREATE TABLE svm6142 COMPRESS AS
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
,cm4  
,cm6  
,cm8  
,cm10 
,cm12 
,cm14 
,cm16 
,cm18 
-- 
,ca4  
,ca6  
,ca8  
,ca10 
,ca12 
,ca14 
,ca16 
,ca18 
--
,cx4  
,cx6  
,cx8  
,cx10 
,cx12 
,cx14 
,cx16 
,cx18 
--
,crr4 
,crr6 
,crr8 
,crr10
,crr12
,crr14
,crr16
,crr18
--
,hh
,d
,w
,mpm
,mph
FROM svm6122
ORDER BY ydate
/

-- rpt

SELECT
pair
,trend
,gatt
,COUNT(pair)
,AVG(g6)
FROM svm6142
GROUP BY pair,trend,gatt
ORDER BY pair,trend,gatt
/


-- Derive NTILE based params:

DROP TABLE svm6162;
CREATE TABLE svm6162 COMPRESS AS
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
FROM svm6142
ORDER BY ydate
/

-- rpt

SELECT
pair
,trend
,gatt
,COUNT(pair)
,AVG(g6)
FROM svm6162
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
FROM svm6162
/

ANALYZE TABLE modsrc COMPUTE STATISTICS;

DROP   TABLE ech_ms610 ;
CREATE TABLE ech_ms610 COMPRESS AS
SELECT
ydate
,trend ech_trend
,g6    ech_g6
,gatt  ech_gatt
,gattn ech_gattn
FROM modsrc
/

ANALYZE TABLE ech_ms610 COMPUTE STATISTICS;

-- I need a copy of the attributes:


DROP   TABLE ech_att;
CREATE TABLE ech_att COMPRESS AS
SELECT
ydate
,att00 ech_att00
,att01 ech_att01
,att02 ech_att02
,att03 ech_att03
,att04 ech_att04
,att05 ech_att05
,att06 ech_att06
,att07 ech_att07
,att08 ech_att08
,att09 ech_att09
,att10 ech_att10
,att11 ech_att11
,att12 ech_att12
,att13 ech_att13
,att14 ech_att14
,att15 ech_att15
,att16 ech_att16
,att17 ech_att17
,att18 ech_att18
,att19 ech_att19
,att20 ech_att20
,att21 ech_att21
,att22 ech_att22
,att23 ech_att23
,att24 ech_att24
,att25 ech_att25
,att26 ech_att26
,att27 ech_att27
,att28 ech_att28
,att29 ech_att29
,att30 ech_att30
,att31 ech_att31
,att32 ech_att32
,att33 ech_att33
,att34 ech_att34
,att35 ech_att35
,att36 ech_att36
,att37 ech_att37
FROM svm6162
/

ANALYZE TABLE ech_att COMPUTE STATISTICS;

-- rpt 
SELECT COUNT(*)FROM svm6102;
SELECT COUNT(*)FROM ech_att;

--
-- egb610.sql
--

-- Creates views and tables for backtesting a forex SVM strategy

PURGE RECYCLEBIN;

-- I created di5min here:
-- /pt/s/rlk/svm8hp/update_di5min.sql

CREATE OR REPLACE VIEW svm6102 AS
SELECT
pair
,ydate
,prdate
,rownum rnum -- acts as t in my time-series
,clse
-- Derive a bunch of attributes from clse, the latest price:
,MIN(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*4 PRECEDING AND CURRENT ROW)min4
,MIN(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*6 PRECEDING AND CURRENT ROW)min6
,MIN(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*8 PRECEDING AND CURRENT ROW)min8
,MIN(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*10 PRECEDING AND CURRENT ROW)min10
,MIN(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*12 PRECEDING AND CURRENT ROW)min12
,MIN(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*14 PRECEDING AND CURRENT ROW)min14
,MIN(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*16 PRECEDING AND CURRENT ROW)min16
,MIN(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*18 PRECEDING AND CURRENT ROW)min18
--
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*4 PRECEDING AND CURRENT ROW)avg4
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*6 PRECEDING AND CURRENT ROW)avg6
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*8 PRECEDING AND CURRENT ROW)avg8
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*10 PRECEDING AND CURRENT ROW)avg10
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*12 PRECEDING AND CURRENT ROW)avg12
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*14 PRECEDING AND CURRENT ROW)avg14
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*16 PRECEDING AND CURRENT ROW)avg16
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*18 PRECEDING AND CURRENT ROW)avg18
--
,MAX(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*4 PRECEDING AND CURRENT ROW)max4
,MAX(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*6 PRECEDING AND CURRENT ROW)max6
,MAX(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*8 PRECEDING AND CURRENT ROW)max8
,MAX(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*10 PRECEDING AND CURRENT ROW)max10
,MAX(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*12 PRECEDING AND CURRENT ROW)max12
,MAX(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*14 PRECEDING AND CURRENT ROW)max14
,MAX(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*16 PRECEDING AND CURRENT ROW)max16
,MAX(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*18 PRECEDING AND CURRENT ROW)max18
,LEAD(clse,12*6,NULL)OVER(PARTITION BY pair ORDER BY ydate)ld6
FROM di5min WHERE pair LIKE'%egb%'
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
FROM svm6102
GROUP BY pair
/

-- Derive trend, clse-relations, moving correlation of clse, and date related params:
DROP TABLE svm6122;
CREATE TABLE svm6122 COMPRESS AS
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
,clse-min4  cm4  
,clse-min6  cm6  
,clse-min8  cm8  
,clse-min10 cm10 
,clse-min12 cm12 
,clse-min14 cm14 
,clse-min16 cm16 
,clse-min18 cm18 
-- clse relation to moving-avg
,clse-avg4  ca4  
,clse-avg6  ca6  
,clse-avg8  ca8  
,clse-avg10 ca10 
,clse-avg12 ca12 
,clse-avg14 ca14 
,clse-avg16 ca16 
,clse-avg18 ca18 
-- clse relation to moving-max
,clse-max4  cx4  
,clse-max6  cx6  
,clse-max8  cx8  
,clse-max10 cx10 
,clse-max12 cx12 
,clse-max14 cx14 
,clse-max16 cx16 
,clse-max18 cx18 
-- Derive more attributes.
-- I want to use CORR() here to help SVM see the shape of the series.
-- But COVAR_POP is more stable:
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*4  PRECEDING AND CURRENT ROW)crr4 
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*6  PRECEDING AND CURRENT ROW)crr6 
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*8  PRECEDING AND CURRENT ROW)crr8 
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*10 PRECEDING AND CURRENT ROW)crr10
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*12 PRECEDING AND CURRENT ROW)crr12
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*14 PRECEDING AND CURRENT ROW)crr14
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*16 PRECEDING AND CURRENT ROW)crr16
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*18 PRECEDING AND CURRENT ROW)crr18
-- Derive date related attributes:
,0+TO_CHAR( ROUND(ydate,'HH24'),'HH24')hh
,0+TO_CHAR(ydate,'D')d
,0+TO_CHAR(ydate,'W')w
-- mpm stands for minutes-past-midnight:
,ROUND( (ydate - trunc(ydate))*24*60 )mpm
-- mph stands for minutes-past-hour:
,0+TO_CHAR(ydate,'MI')mph
FROM svm6102
ORDER BY ydate
/

-- rpt

SELECT
pair
,COUNT(pair)
,MIN(clse),MAX(clse)
,MIN(ydate),MAX(ydate)
FROM svm6122
GROUP BY pair
/

-- Prepare for derivation of NTILE based params:

DROP TABLE svm6142;
CREATE TABLE svm6142 COMPRESS AS
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
,cm4  
,cm6  
,cm8  
,cm10 
,cm12 
,cm14 
,cm16 
,cm18 
-- 
,ca4  
,ca6  
,ca8  
,ca10 
,ca12 
,ca14 
,ca16 
,ca18 
--
,cx4  
,cx6  
,cx8  
,cx10 
,cx12 
,cx14 
,cx16 
,cx18 
--
,crr4 
,crr6 
,crr8 
,crr10
,crr12
,crr14
,crr16
,crr18
--
,hh
,d
,w
,mpm
,mph
FROM svm6122
ORDER BY ydate
/

-- rpt

SELECT
pair
,trend
,gatt
,COUNT(pair)
,AVG(g6)
FROM svm6142
GROUP BY pair,trend,gatt
ORDER BY pair,trend,gatt
/


-- Derive NTILE based params:

DROP TABLE svm6162;
CREATE TABLE svm6162 COMPRESS AS
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
FROM svm6142
ORDER BY ydate
/

-- rpt

SELECT
pair
,trend
,gatt
,COUNT(pair)
,AVG(g6)
FROM svm6162
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
FROM svm6162
/

ANALYZE TABLE modsrc COMPUTE STATISTICS;

DROP   TABLE egb_ms610 ;
CREATE TABLE egb_ms610 COMPRESS AS
SELECT
ydate
,trend egb_trend
,g6    egb_g6
,gatt  egb_gatt
,gattn egb_gattn
FROM modsrc
/

ANALYZE TABLE egb_ms610 COMPUTE STATISTICS;

-- I need a copy of the attributes:


DROP   TABLE egb_att;
CREATE TABLE egb_att COMPRESS AS
SELECT
ydate
,att00 egb_att00
,att01 egb_att01
,att02 egb_att02
,att03 egb_att03
,att04 egb_att04
,att05 egb_att05
,att06 egb_att06
,att07 egb_att07
,att08 egb_att08
,att09 egb_att09
,att10 egb_att10
,att11 egb_att11
,att12 egb_att12
,att13 egb_att13
,att14 egb_att14
,att15 egb_att15
,att16 egb_att16
,att17 egb_att17
,att18 egb_att18
,att19 egb_att19
,att20 egb_att20
,att21 egb_att21
,att22 egb_att22
,att23 egb_att23
,att24 egb_att24
,att25 egb_att25
,att26 egb_att26
,att27 egb_att27
,att28 egb_att28
,att29 egb_att29
,att30 egb_att30
,att31 egb_att31
,att32 egb_att32
,att33 egb_att33
,att34 egb_att34
,att35 egb_att35
,att36 egb_att36
,att37 egb_att37
FROM svm6162
/

ANALYZE TABLE egb_att COMPUTE STATISTICS;

-- rpt 
SELECT COUNT(*)FROM svm6102;
SELECT COUNT(*)FROM egb_att;

--
-- ejp610.sql
--

-- Creates views and tables for backtesting a forex SVM strategy

PURGE RECYCLEBIN;

-- I created di5min here:
-- /pt/s/rlk/svm8hp/update_di5min.sql

CREATE OR REPLACE VIEW svm6102 AS
SELECT
pair
,ydate
,prdate
,rownum rnum -- acts as t in my time-series
,clse
-- Derive a bunch of attributes from clse, the latest price:
,MIN(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*4 PRECEDING AND CURRENT ROW)min4
,MIN(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*6 PRECEDING AND CURRENT ROW)min6
,MIN(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*8 PRECEDING AND CURRENT ROW)min8
,MIN(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*10 PRECEDING AND CURRENT ROW)min10
,MIN(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*12 PRECEDING AND CURRENT ROW)min12
,MIN(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*14 PRECEDING AND CURRENT ROW)min14
,MIN(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*16 PRECEDING AND CURRENT ROW)min16
,MIN(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*18 PRECEDING AND CURRENT ROW)min18
--
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*4 PRECEDING AND CURRENT ROW)avg4
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*6 PRECEDING AND CURRENT ROW)avg6
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*8 PRECEDING AND CURRENT ROW)avg8
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*10 PRECEDING AND CURRENT ROW)avg10
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*12 PRECEDING AND CURRENT ROW)avg12
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*14 PRECEDING AND CURRENT ROW)avg14
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*16 PRECEDING AND CURRENT ROW)avg16
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*18 PRECEDING AND CURRENT ROW)avg18
--
,MAX(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*4 PRECEDING AND CURRENT ROW)max4
,MAX(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*6 PRECEDING AND CURRENT ROW)max6
,MAX(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*8 PRECEDING AND CURRENT ROW)max8
,MAX(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*10 PRECEDING AND CURRENT ROW)max10
,MAX(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*12 PRECEDING AND CURRENT ROW)max12
,MAX(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*14 PRECEDING AND CURRENT ROW)max14
,MAX(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*16 PRECEDING AND CURRENT ROW)max16
,MAX(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*18 PRECEDING AND CURRENT ROW)max18
,LEAD(clse,12*6,NULL)OVER(PARTITION BY pair ORDER BY ydate)ld6
FROM di5min WHERE pair LIKE'%ejp%'
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
FROM svm6102
GROUP BY pair
/

-- Derive trend, clse-relations, moving correlation of clse, and date related params:
DROP TABLE svm6122;
CREATE TABLE svm6122 COMPRESS AS
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
,clse-min4  cm4  
,clse-min6  cm6  
,clse-min8  cm8  
,clse-min10 cm10 
,clse-min12 cm12 
,clse-min14 cm14 
,clse-min16 cm16 
,clse-min18 cm18 
-- clse relation to moving-avg
,clse-avg4  ca4  
,clse-avg6  ca6  
,clse-avg8  ca8  
,clse-avg10 ca10 
,clse-avg12 ca12 
,clse-avg14 ca14 
,clse-avg16 ca16 
,clse-avg18 ca18 
-- clse relation to moving-max
,clse-max4  cx4  
,clse-max6  cx6  
,clse-max8  cx8  
,clse-max10 cx10 
,clse-max12 cx12 
,clse-max14 cx14 
,clse-max16 cx16 
,clse-max18 cx18 
-- Derive more attributes.
-- I want to use CORR() here to help SVM see the shape of the series.
-- But COVAR_POP is more stable:
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*4  PRECEDING AND CURRENT ROW)crr4 
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*6  PRECEDING AND CURRENT ROW)crr6 
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*8  PRECEDING AND CURRENT ROW)crr8 
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*10 PRECEDING AND CURRENT ROW)crr10
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*12 PRECEDING AND CURRENT ROW)crr12
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*14 PRECEDING AND CURRENT ROW)crr14
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*16 PRECEDING AND CURRENT ROW)crr16
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*18 PRECEDING AND CURRENT ROW)crr18
-- Derive date related attributes:
,0+TO_CHAR( ROUND(ydate,'HH24'),'HH24')hh
,0+TO_CHAR(ydate,'D')d
,0+TO_CHAR(ydate,'W')w
-- mpm stands for minutes-past-midnight:
,ROUND( (ydate - trunc(ydate))*24*60 )mpm
-- mph stands for minutes-past-hour:
,0+TO_CHAR(ydate,'MI')mph
FROM svm6102
ORDER BY ydate
/

-- rpt

SELECT
pair
,COUNT(pair)
,MIN(clse),MAX(clse)
,MIN(ydate),MAX(ydate)
FROM svm6122
GROUP BY pair
/

-- Prepare for derivation of NTILE based params:

DROP TABLE svm6142;
CREATE TABLE svm6142 COMPRESS AS
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
,cm4  
,cm6  
,cm8  
,cm10 
,cm12 
,cm14 
,cm16 
,cm18 
-- 
,ca4  
,ca6  
,ca8  
,ca10 
,ca12 
,ca14 
,ca16 
,ca18 
--
,cx4  
,cx6  
,cx8  
,cx10 
,cx12 
,cx14 
,cx16 
,cx18 
--
,crr4 
,crr6 
,crr8 
,crr10
,crr12
,crr14
,crr16
,crr18
--
,hh
,d
,w
,mpm
,mph
FROM svm6122
ORDER BY ydate
/

-- rpt

SELECT
pair
,trend
,gatt
,COUNT(pair)
,AVG(g6)
FROM svm6142
GROUP BY pair,trend,gatt
ORDER BY pair,trend,gatt
/


-- Derive NTILE based params:

DROP TABLE svm6162;
CREATE TABLE svm6162 COMPRESS AS
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
FROM svm6142
ORDER BY ydate
/

-- rpt

SELECT
pair
,trend
,gatt
,COUNT(pair)
,AVG(g6)
FROM svm6162
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
FROM svm6162
/

ANALYZE TABLE modsrc COMPUTE STATISTICS;

DROP   TABLE ejp_ms610 ;
CREATE TABLE ejp_ms610 COMPRESS AS
SELECT
ydate
,trend ejp_trend
,g6    ejp_g6
,gatt  ejp_gatt
,gattn ejp_gattn
FROM modsrc
/

ANALYZE TABLE ejp_ms610 COMPUTE STATISTICS;

-- I need a copy of the attributes:


DROP   TABLE ejp_att;
CREATE TABLE ejp_att COMPRESS AS
SELECT
ydate
,att00 ejp_att00
,att01 ejp_att01
,att02 ejp_att02
,att03 ejp_att03
,att04 ejp_att04
,att05 ejp_att05
,att06 ejp_att06
,att07 ejp_att07
,att08 ejp_att08
,att09 ejp_att09
,att10 ejp_att10
,att11 ejp_att11
,att12 ejp_att12
,att13 ejp_att13
,att14 ejp_att14
,att15 ejp_att15
,att16 ejp_att16
,att17 ejp_att17
,att18 ejp_att18
,att19 ejp_att19
,att20 ejp_att20
,att21 ejp_att21
,att22 ejp_att22
,att23 ejp_att23
,att24 ejp_att24
,att25 ejp_att25
,att26 ejp_att26
,att27 ejp_att27
,att28 ejp_att28
,att29 ejp_att29
,att30 ejp_att30
,att31 ejp_att31
,att32 ejp_att32
,att33 ejp_att33
,att34 ejp_att34
,att35 ejp_att35
,att36 ejp_att36
,att37 ejp_att37
FROM svm6162
/

ANALYZE TABLE ejp_att COMPUTE STATISTICS;

-- rpt 
SELECT COUNT(*)FROM svm6102;
SELECT COUNT(*)FROM ejp_att;

--
-- ajp610.sql
--

-- Creates views and tables for backtesting a forex SVM strategy

PURGE RECYCLEBIN;

-- I created di5min here:
-- /pt/s/rlk/svm8hp/update_di5min.sql

CREATE OR REPLACE VIEW svm6102 AS
SELECT
pair
,ydate
,prdate
,rownum rnum -- acts as t in my time-series
,clse
-- Derive a bunch of attributes from clse, the latest price:
,MIN(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*4 PRECEDING AND CURRENT ROW)min4
,MIN(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*6 PRECEDING AND CURRENT ROW)min6
,MIN(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*8 PRECEDING AND CURRENT ROW)min8
,MIN(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*10 PRECEDING AND CURRENT ROW)min10
,MIN(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*12 PRECEDING AND CURRENT ROW)min12
,MIN(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*14 PRECEDING AND CURRENT ROW)min14
,MIN(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*16 PRECEDING AND CURRENT ROW)min16
,MIN(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*18 PRECEDING AND CURRENT ROW)min18
--
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*4 PRECEDING AND CURRENT ROW)avg4
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*6 PRECEDING AND CURRENT ROW)avg6
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*8 PRECEDING AND CURRENT ROW)avg8
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*10 PRECEDING AND CURRENT ROW)avg10
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*12 PRECEDING AND CURRENT ROW)avg12
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*14 PRECEDING AND CURRENT ROW)avg14
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*16 PRECEDING AND CURRENT ROW)avg16
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*18 PRECEDING AND CURRENT ROW)avg18
--
,MAX(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*4 PRECEDING AND CURRENT ROW)max4
,MAX(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*6 PRECEDING AND CURRENT ROW)max6
,MAX(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*8 PRECEDING AND CURRENT ROW)max8
,MAX(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*10 PRECEDING AND CURRENT ROW)max10
,MAX(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*12 PRECEDING AND CURRENT ROW)max12
,MAX(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*14 PRECEDING AND CURRENT ROW)max14
,MAX(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*16 PRECEDING AND CURRENT ROW)max16
,MAX(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*18 PRECEDING AND CURRENT ROW)max18
,LEAD(clse,12*6,NULL)OVER(PARTITION BY pair ORDER BY ydate)ld6
FROM di5min WHERE pair LIKE'%ajp%'
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
FROM svm6102
GROUP BY pair
/

-- Derive trend, clse-relations, moving correlation of clse, and date related params:
DROP TABLE svm6122;
CREATE TABLE svm6122 COMPRESS AS
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
,clse-min4  cm4  
,clse-min6  cm6  
,clse-min8  cm8  
,clse-min10 cm10 
,clse-min12 cm12 
,clse-min14 cm14 
,clse-min16 cm16 
,clse-min18 cm18 
-- clse relation to moving-avg
,clse-avg4  ca4  
,clse-avg6  ca6  
,clse-avg8  ca8  
,clse-avg10 ca10 
,clse-avg12 ca12 
,clse-avg14 ca14 
,clse-avg16 ca16 
,clse-avg18 ca18 
-- clse relation to moving-max
,clse-max4  cx4  
,clse-max6  cx6  
,clse-max8  cx8  
,clse-max10 cx10 
,clse-max12 cx12 
,clse-max14 cx14 
,clse-max16 cx16 
,clse-max18 cx18 
-- Derive more attributes.
-- I want to use CORR() here to help SVM see the shape of the series.
-- But COVAR_POP is more stable:
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*4  PRECEDING AND CURRENT ROW)crr4 
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*6  PRECEDING AND CURRENT ROW)crr6 
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*8  PRECEDING AND CURRENT ROW)crr8 
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*10 PRECEDING AND CURRENT ROW)crr10
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*12 PRECEDING AND CURRENT ROW)crr12
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*14 PRECEDING AND CURRENT ROW)crr14
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*16 PRECEDING AND CURRENT ROW)crr16
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*18 PRECEDING AND CURRENT ROW)crr18
-- Derive date related attributes:
,0+TO_CHAR( ROUND(ydate,'HH24'),'HH24')hh
,0+TO_CHAR(ydate,'D')d
,0+TO_CHAR(ydate,'W')w
-- mpm stands for minutes-past-midnight:
,ROUND( (ydate - trunc(ydate))*24*60 )mpm
-- mph stands for minutes-past-hour:
,0+TO_CHAR(ydate,'MI')mph
FROM svm6102
ORDER BY ydate
/

-- rpt

SELECT
pair
,COUNT(pair)
,MIN(clse),MAX(clse)
,MIN(ydate),MAX(ydate)
FROM svm6122
GROUP BY pair
/

-- Prepare for derivation of NTILE based params:

DROP TABLE svm6142;
CREATE TABLE svm6142 COMPRESS AS
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
,cm4  
,cm6  
,cm8  
,cm10 
,cm12 
,cm14 
,cm16 
,cm18 
-- 
,ca4  
,ca6  
,ca8  
,ca10 
,ca12 
,ca14 
,ca16 
,ca18 
--
,cx4  
,cx6  
,cx8  
,cx10 
,cx12 
,cx14 
,cx16 
,cx18 
--
,crr4 
,crr6 
,crr8 
,crr10
,crr12
,crr14
,crr16
,crr18
--
,hh
,d
,w
,mpm
,mph
FROM svm6122
ORDER BY ydate
/

-- rpt

SELECT
pair
,trend
,gatt
,COUNT(pair)
,AVG(g6)
FROM svm6142
GROUP BY pair,trend,gatt
ORDER BY pair,trend,gatt
/


-- Derive NTILE based params:

DROP TABLE svm6162;
CREATE TABLE svm6162 COMPRESS AS
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
FROM svm6142
ORDER BY ydate
/

-- rpt

SELECT
pair
,trend
,gatt
,COUNT(pair)
,AVG(g6)
FROM svm6162
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
FROM svm6162
/

ANALYZE TABLE modsrc COMPUTE STATISTICS;

DROP   TABLE ajp_ms610 ;
CREATE TABLE ajp_ms610 COMPRESS AS
SELECT
ydate
,trend ajp_trend
,g6    ajp_g6
,gatt  ajp_gatt
,gattn ajp_gattn
FROM modsrc
/

ANALYZE TABLE ajp_ms610 COMPUTE STATISTICS;

-- I need a copy of the attributes:


DROP   TABLE ajp_att;
CREATE TABLE ajp_att COMPRESS AS
SELECT
ydate
,att00 ajp_att00
,att01 ajp_att01
,att02 ajp_att02
,att03 ajp_att03
,att04 ajp_att04
,att05 ajp_att05
,att06 ajp_att06
,att07 ajp_att07
,att08 ajp_att08
,att09 ajp_att09
,att10 ajp_att10
,att11 ajp_att11
,att12 ajp_att12
,att13 ajp_att13
,att14 ajp_att14
,att15 ajp_att15
,att16 ajp_att16
,att17 ajp_att17
,att18 ajp_att18
,att19 ajp_att19
,att20 ajp_att20
,att21 ajp_att21
,att22 ajp_att22
,att23 ajp_att23
,att24 ajp_att24
,att25 ajp_att25
,att26 ajp_att26
,att27 ajp_att27
,att28 ajp_att28
,att29 ajp_att29
,att30 ajp_att30
,att31 ajp_att31
,att32 ajp_att32
,att33 ajp_att33
,att34 ajp_att34
,att35 ajp_att35
,att36 ajp_att36
,att37 ajp_att37
FROM svm6162
/

ANALYZE TABLE ajp_att COMPUTE STATISTICS;

-- rpt 
SELECT COUNT(*)FROM svm6102;
SELECT COUNT(*)FROM ajp_att;

