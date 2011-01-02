--
-- stk10.sql
--

-- Creates views and tables for demonstrating SVM.

CREATE OR REPLACE VIEW stk10 AS
SELECT
tkr
,ydate
,tkr||ydate tkrdate
,clse
-- Derive some attributes from clse.
,MIN(clse)OVER(PARTITION BY tkr ORDER BY ydate ROWS BETWEEN 12*4 PRECEDING AND CURRENT ROW)min4
,AVG(clse)OVER(PARTITION BY tkr ORDER BY ydate ROWS BETWEEN 12*4 PRECEDING AND CURRENT ROW)avg4
,MAX(clse)OVER(PARTITION BY tkr ORDER BY ydate ROWS BETWEEN 12*4 PRECEDING AND CURRENT ROW)max4
,LEAD(clse,12*4,NULL)OVER(PARTITION BY tkr ORDER BY ydate)ld4
FROM dukas5min_stk WHERE UPPER(tkr)='&1'
ORDER BY ydate
/

-- rpt

SELECT
tkr
,COUNT(tkr)
,MIN(clse),MAX(clse)
,MIN(avg4),MAX(avg4)
,MIN(ydate),MAX(ydate)
FROM stk10
GROUP BY tkr
/

-- Derive trend, clse-relations, moving correlation of clse, and date related params:
DROP TABLE stk12;
CREATE TABLE stk12 COMPRESS AS
SELECT
tkr
,ydate
,tkrdate
,clse
-- g4 is important. I want to predict g4:
,ld4 - clse g4
,SIGN(avg4 - LAG(avg4,2,NULL)OVER(PARTITION BY tkr ORDER BY ydate))trend
-- I want more attributes from the ones I derived above:
-- clse relation to moving-min
,clse-min4  cm4  
-- clse relation to moving-avg
,clse-avg4  ca4  
-- clse relation to moving-max
,clse-max4  cx4  
-- Derive date related attributes:
,0+TO_CHAR( ROUND(ydate,'HH24'),'HH24')hh
,0+TO_CHAR(ydate,'D')d
,0+TO_CHAR(ydate,'W')w
-- mpm stands for minutes-past-midnight:
,ROUND( (ydate - trunc(ydate))*24*60 )mpm
-- mph stands for minutes-past-hour:
,0+TO_CHAR(ydate,'MI')mph
FROM stk10
ORDER BY ydate
/

-- rpt

SELECT
tkr
,COUNT(tkr)
,MIN(clse),MAX(clse)
,MIN(ydate),MAX(ydate)
FROM stk12
GROUP BY tkr
/

exit

-- Prepare for derivation of NTILE based parameters.
-- Also derive the "trend" parameter:

DROP TABLE stk14;
CREATE TABLE stk14 COMPRESS AS
SELECT
tkr
,ydate
,tkrdate
,clse
,g4
,CASE WHEN g4 IS NULL THEN NULL WHEN g4 > 0.50 THEN 'up' ELSE 'nup' END gatt
,CASE WHEN g4 IS NULL THEN NULL WHEN g4< -0.50 THEN 'up' ELSE 'nup' END gattn
,CASE WHEN trend IS NULL THEN 1
      WHEN trend =0      THEN 1
      ELSE trend END trend
,cm4  
,ca4  
,cx4  
,hh
,d
,w
,mpm
,mph
FROM stk12
ORDER BY ydate
/

-- rpt

SELECT
tkr
,trend
,gatt
,COUNT(tkr)
,AVG(g4)
FROM stk14
GROUP BY tkr,trend,gatt
ORDER BY tkr,trend,gatt
/

-- Derive NTILE based params:

DROP TABLE stk16;
CREATE TABLE stk16 COMPRESS AS
SELECT
tkr
,ydate
,tkrdate
,clse
,g4
,gatt
,gattn
,trend
,NTILE(9)OVER(PARTITION BY trend,tkr ORDER BY cm4)att00
,NTILE(9)OVER(PARTITION BY trend,tkr ORDER BY ca4)att01
,NTILE(9)OVER(PARTITION BY trend,tkr ORDER BY cx4)att02
,hh  att03
,d   att04
,w   att05
,mpm att06
,mph att07
,trend att08
FROM stk14
ORDER BY ydate
/

-- rpt

SELECT
tkr
,trend
,gatt
,COUNT(tkr)
,AVG(g4)
FROM stk16
GROUP BY tkr,trend,gatt
ORDER BY tkr,trend,gatt
/


DROP TABLE stk_ms;
CREATE TABLE stk_ms COMPRESS AS
SELECT
tkr
,ydate
,tkrdate
,trend
,g4
,gatt
,gattn
,SUM(g4)OVER(PARTITION BY trend,att00 ORDER BY ydate ROWS BETWEEN 12*22*30 PRECEDING AND CURRENT ROW)g00
,SUM(g4)OVER(PARTITION BY trend,att01 ORDER BY ydate ROWS BETWEEN 12*22*30 PRECEDING AND CURRENT ROW)g01
,SUM(g4)OVER(PARTITION BY trend,att02 ORDER BY ydate ROWS BETWEEN 12*22*30 PRECEDING AND CURRENT ROW)g02
,SUM(g4)OVER(PARTITION BY trend,att03 ORDER BY ydate ROWS BETWEEN 12*22*30 PRECEDING AND CURRENT ROW)g03
,SUM(g4)OVER(PARTITION BY trend,att04 ORDER BY ydate ROWS BETWEEN 12*22*30 PRECEDING AND CURRENT ROW)g04
,SUM(g4)OVER(PARTITION BY trend,att05 ORDER BY ydate ROWS BETWEEN 12*22*30 PRECEDING AND CURRENT ROW)g05
,SUM(g4)OVER(PARTITION BY trend,att06 ORDER BY ydate ROWS BETWEEN 12*22*30 PRECEDING AND CURRENT ROW)g06
,SUM(g4)OVER(PARTITION BY trend,att07 ORDER BY ydate ROWS BETWEEN 12*22*30 PRECEDING AND CURRENT ROW)g07
,SUM(g4)OVER(PARTITION BY trend,att08 ORDER BY ydate ROWS BETWEEN 12*22*30 PRECEDING AND CURRENT ROW)g08
FROM stk16
/

-- rpt

SELECT
tkr
,trend
,gatt
,COUNT(tkr)
,AVG(g4)
FROM stk_ms
GROUP BY tkr,trend,gatt
ORDER BY tkr,trend,gatt
/

exit
