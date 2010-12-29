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
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*6 PRECEDING AND CURRENT ROW)avg6
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

-- Prepare for derivation of NTILE based parameters.
-- Also derive the "trend" parameter:

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
,ca6  
,cx6  
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
,NTILE(9)OVER(PARTITION BY trend,pair ORDER BY cm6)att00
,NTILE(9)OVER(PARTITION BY trend,pair ORDER BY ca6)att01
,NTILE(9)OVER(PARTITION BY trend,pair ORDER BY cx6)att02
,hh  att03
,d   att04
,w   att05
,mpm att06
,mph att07
,trend att08
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


DROP TABLE jpy_ms;
CREATE TABLE jpy_ms COMPRESS AS
SELECT
pair
,ydate
,prdate
,trend
,g6
,gatt
,gattn
,SUM(g6)OVER(PARTITION BY trend,att00 ORDER BY ydate ROWS BETWEEN 12*22*30 PRECEDING AND CURRENT ROW)g00
,SUM(g6)OVER(PARTITION BY trend,att01 ORDER BY ydate ROWS BETWEEN 12*22*30 PRECEDING AND CURRENT ROW)g01
,SUM(g6)OVER(PARTITION BY trend,att02 ORDER BY ydate ROWS BETWEEN 12*22*30 PRECEDING AND CURRENT ROW)g02
,SUM(g6)OVER(PARTITION BY trend,att03 ORDER BY ydate ROWS BETWEEN 12*22*30 PRECEDING AND CURRENT ROW)g03
,SUM(g6)OVER(PARTITION BY trend,att04 ORDER BY ydate ROWS BETWEEN 12*22*30 PRECEDING AND CURRENT ROW)g04
,SUM(g6)OVER(PARTITION BY trend,att05 ORDER BY ydate ROWS BETWEEN 12*22*30 PRECEDING AND CURRENT ROW)g05
,SUM(g6)OVER(PARTITION BY trend,att06 ORDER BY ydate ROWS BETWEEN 12*22*30 PRECEDING AND CURRENT ROW)g06
,SUM(g6)OVER(PARTITION BY trend,att07 ORDER BY ydate ROWS BETWEEN 12*22*30 PRECEDING AND CURRENT ROW)g07
,SUM(g6)OVER(PARTITION BY trend,att08 ORDER BY ydate ROWS BETWEEN 12*22*30 PRECEDING AND CURRENT ROW)g08
FROM jpy16
/

-- rpt

SELECT
pair
,trend
,gatt
,COUNT(pair)
,AVG(g6)
FROM jpy_ms
GROUP BY pair,trend,gatt
ORDER BY pair,trend,gatt
/

exit
