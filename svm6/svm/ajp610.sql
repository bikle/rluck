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

