--
-- stk10.sql
--

-- Creates views and tables for demonstrating SVM.

-- Get Mon-Thurs
DROP TABLE stk10p14;

PURGE RECYCLEBIN;

CREATE TABLE stk10p14 COMPRESS AS
SELECT
tkr
,ydate
,clse
FROM di5min_stk
WHERE UPPER(tkr)='&1'
AND 0+TO_CHAR(ydate,'D')BETWEEN 1 AND 4
AND 0+TO_CHAR(ydate,'HH24')BETWEEN 13 AND 20
ORDER BY ydate
/

-- Get Fri
DROP TABLE stk10p5;

CREATE TABLE stk10p5 COMPRESS AS
SELECT
tkr
,ydate
,clse
FROM di5min_stk
WHERE UPPER(tkr)='&1'
AND 0+TO_CHAR(ydate,'D')=5
AND 0+TO_CHAR(ydate,'HH24')BETWEEN 13 AND 20
ORDER BY ydate
/

-- Get Mon
DROP TABLE stk10f1;

CREATE TABLE stk10f1 COMPRESS AS
SELECT
tkr
,ydate
,clse
FROM di5min_stk
WHERE UPPER(tkr)='&1'
AND 0+TO_CHAR(ydate,'D')=1
AND 0+TO_CHAR(ydate,'HH24')BETWEEN 13 AND 20
ORDER BY ydate
/

-- Get Tues - Fri
DROP TABLE stk10f25;

CREATE TABLE stk10f25 COMPRESS AS
SELECT
tkr
,ydate
,clse
FROM di5min_stk
WHERE UPPER(tkr)='&1'
AND 0+TO_CHAR(ydate,'D')BETWEEN 2 AND 5
AND 0+TO_CHAR(ydate,'HH24')BETWEEN 13 AND 20
ORDER BY ydate
/

-- Join em
DROP TABLE stk10pf;

-- Deal with m-thr 1st
CREATE TABLE stk10pf AS
SELECT
p.tkr
,p.ydate
,p.clse
,f.clse clse2
FROM stk10p14 p, stk10f25 f
WHERE p.ydate + 1 = f.ydate
/

-- Deal with Fri (day 5 joined with day 1)
INSERT INTO stk10pf(tkr,ydate,clse,clse2)
SELECT
p.tkr
,p.ydate
,p.clse
,f.clse clse2
FROM stk10p5 p, stk10f1 f
WHERE p.ydate + 3 = f.ydate
/

-- rpt
select count(*)from stk10pf;

DROP VIEW stk10;

DROP TABLE stk10;

CREATE TABLE stk10 COMPRESS AS
SELECT
tkr
,ydate
,tkr||ydate tkrdate
,clse
,clse2
,rownum rnum -- acts as t in my time-series
-- Derive some attributes from clse.
,MIN(clse)OVER(PARTITION BY tkr ORDER BY ydate ROWS BETWEEN 12*2 PRECEDING AND CURRENT ROW)min2
,MIN(clse)OVER(PARTITION BY tkr ORDER BY ydate ROWS BETWEEN 12*3 PRECEDING AND CURRENT ROW)min3
,MIN(clse)OVER(PARTITION BY tkr ORDER BY ydate ROWS BETWEEN 12*4 PRECEDING AND CURRENT ROW)min4
,MIN(clse)OVER(PARTITION BY tkr ORDER BY ydate ROWS BETWEEN 12*5 PRECEDING AND CURRENT ROW)min5
,MIN(clse)OVER(PARTITION BY tkr ORDER BY ydate ROWS BETWEEN 12*6 PRECEDING AND CURRENT ROW)min6
,MIN(clse)OVER(PARTITION BY tkr ORDER BY ydate ROWS BETWEEN 12*7 PRECEDING AND CURRENT ROW)min7
,MIN(clse)OVER(PARTITION BY tkr ORDER BY ydate ROWS BETWEEN 12*8 PRECEDING AND CURRENT ROW)min8
,AVG(clse)OVER(PARTITION BY tkr ORDER BY ydate ROWS BETWEEN 12*2 PRECEDING AND CURRENT ROW)avg2
,AVG(clse)OVER(PARTITION BY tkr ORDER BY ydate ROWS BETWEEN 12*3 PRECEDING AND CURRENT ROW)avg3
,AVG(clse)OVER(PARTITION BY tkr ORDER BY ydate ROWS BETWEEN 12*4 PRECEDING AND CURRENT ROW)avg4
,AVG(clse)OVER(PARTITION BY tkr ORDER BY ydate ROWS BETWEEN 12*5 PRECEDING AND CURRENT ROW)avg5
,AVG(clse)OVER(PARTITION BY tkr ORDER BY ydate ROWS BETWEEN 12*6 PRECEDING AND CURRENT ROW)avg6
,AVG(clse)OVER(PARTITION BY tkr ORDER BY ydate ROWS BETWEEN 12*7 PRECEDING AND CURRENT ROW)avg7
,AVG(clse)OVER(PARTITION BY tkr ORDER BY ydate ROWS BETWEEN 12*8 PRECEDING AND CURRENT ROW)avg8
,MAX(clse)OVER(PARTITION BY tkr ORDER BY ydate ROWS BETWEEN 12*2 PRECEDING AND CURRENT ROW)max2
,MAX(clse)OVER(PARTITION BY tkr ORDER BY ydate ROWS BETWEEN 12*3 PRECEDING AND CURRENT ROW)max3
,MAX(clse)OVER(PARTITION BY tkr ORDER BY ydate ROWS BETWEEN 12*4 PRECEDING AND CURRENT ROW)max4
,MAX(clse)OVER(PARTITION BY tkr ORDER BY ydate ROWS BETWEEN 12*5 PRECEDING AND CURRENT ROW)max5
,MAX(clse)OVER(PARTITION BY tkr ORDER BY ydate ROWS BETWEEN 12*6 PRECEDING AND CURRENT ROW)max6
,MAX(clse)OVER(PARTITION BY tkr ORDER BY ydate ROWS BETWEEN 12*7 PRECEDING AND CURRENT ROW)max7
,MAX(clse)OVER(PARTITION BY tkr ORDER BY ydate ROWS BETWEEN 12*8 PRECEDING AND CURRENT ROW)max8
FROM stk10pf
WHERE UPPER(tkr)='&1'
AND 0+TO_CHAR(ydate,'D')BETWEEN 1 AND 5
AND 0+TO_CHAR(ydate,'HH24')BETWEEN 13 AND 20
ORDER BY ydate
/

ANALYZE TABLE stk10 COMPUTE STATISTICS;

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

exit

-- Derive trend, clse-relations, moving correlation of clse, and date related params:
DROP TABLE stk12;
CREATE TABLE stk12 COMPRESS AS
SELECT
tkr
,ydate
,tkrdate
,clse
,rnum
-- g4 is important. I want to predict g4:
,clse2 - clse g4
,SIGN(avg4 - LAG(avg4,2,NULL)OVER(PARTITION BY tkr ORDER BY ydate))trend
-- I want more attributes from the ones I derived above:
-- clse relation to moving-min
,clse-min2  cm2
,clse-min3  cm3
,clse-min4  cm4
,clse-min5  cm5
,clse-min6  cm6
,clse-min7  cm7
,clse-min8  cm8
-- clse relation to moving-avg
,clse-avg2  ca2
,clse-avg3  ca3
,clse-avg4  ca4
,clse-avg5  ca5
,clse-avg6  ca6
,clse-avg7  ca7
,clse-avg8  ca8
-- clse relation to moving-max
,clse-max2  cx2
,clse-max3  cx3
,clse-max4  cx4
,clse-max5  cx5
,clse-max6  cx6
,clse-max7  cx7
,clse-max8  cx8
-- Derive date related attributes:
,0+TO_CHAR( ROUND(ydate,'HH24'),'HH24')hh
,0+TO_CHAR(ydate,'D')d
,0+TO_CHAR(ydate,'W')w
-- mpm stands for minutes-past-midnight:
,ROUND( (ydate - trunc(ydate))*24*60 )mpm
-- mph stands for minutes-past-hour:
,0+TO_CHAR(ydate,'MI')mph
-- Price in the future:
,clse2
FROM stk10, stk10f
-- Specify the future here.
-- 1 day in the future to be exact
WHERE ydate2-ydate = 1
ORDER BY ydate
/

exit

-- rpt

SELECT
tkr
,COUNT(tkr)
,MIN(clse),MAX(clse)
,MIN(ydate),MAX(ydate)
FROM stk12
GROUP BY tkr
/

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
,CASE WHEN g4 IS NULL THEN NULL WHEN g4/clse >  0.30/120 THEN 'up' ELSE 'nup' END gatt
,CASE WHEN g4 IS NULL THEN NULL WHEN g4/clse < -0.30/120 THEN 'up' ELSE 'nup' END gattn
,CASE WHEN trend IS NULL THEN 1
      WHEN trend =0      THEN 1
      ELSE trend END trend
,cm2
,cm3
,cm4
,cm5
,cm6
,cm7
,cm8
,ca2
,ca3
,ca4
,ca5
,ca6
,ca7
,ca8
,cx2
,cx3
,cx4
,cx5
,cx6
,cx7
,cx8
,hh
,d
,w
,mpm
,mph
FROM stk12
-- Guard against divide by 0:
WHERE clse > 0
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
,NTILE(9)OVER(PARTITION BY trend,tkr ORDER BY cm2)att00
,NTILE(9)OVER(PARTITION BY trend,tkr ORDER BY cm3)att01
,NTILE(9)OVER(PARTITION BY trend,tkr ORDER BY cm4)att02
,NTILE(9)OVER(PARTITION BY trend,tkr ORDER BY cm5)att03
,NTILE(9)OVER(PARTITION BY trend,tkr ORDER BY cm6)att04
,NTILE(9)OVER(PARTITION BY trend,tkr ORDER BY cm7)att05
,NTILE(9)OVER(PARTITION BY trend,tkr ORDER BY cm8)att06
,NTILE(9)OVER(PARTITION BY trend,tkr ORDER BY ca2)att07
,NTILE(9)OVER(PARTITION BY trend,tkr ORDER BY ca3)att08
,NTILE(9)OVER(PARTITION BY trend,tkr ORDER BY ca4)att09
,NTILE(9)OVER(PARTITION BY trend,tkr ORDER BY ca5)att10
,NTILE(9)OVER(PARTITION BY trend,tkr ORDER BY ca6)att11
,NTILE(9)OVER(PARTITION BY trend,tkr ORDER BY ca7)att12
,NTILE(9)OVER(PARTITION BY trend,tkr ORDER BY ca8)att13
,NTILE(9)OVER(PARTITION BY trend,tkr ORDER BY cx2)att14
,NTILE(9)OVER(PARTITION BY trend,tkr ORDER BY cx3)att15
,NTILE(9)OVER(PARTITION BY trend,tkr ORDER BY cx4)att16
,NTILE(9)OVER(PARTITION BY trend,tkr ORDER BY cx5)att17
,NTILE(9)OVER(PARTITION BY trend,tkr ORDER BY cx6)att18
,NTILE(9)OVER(PARTITION BY trend,tkr ORDER BY cx7)att19
,NTILE(9)OVER(PARTITION BY trend,tkr ORDER BY cx8)att20
,hh  att21
,d   att22
,w   att23
,mpm att24
,mph att25
,trend att26
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

-- Now I derive goodness attributes:

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
,SUM(g4)OVER(PARTITION BY trend,att09 ORDER BY ydate ROWS BETWEEN 12*22*30 PRECEDING AND CURRENT ROW)g09
,SUM(g4)OVER(PARTITION BY trend,att10 ORDER BY ydate ROWS BETWEEN 12*22*30 PRECEDING AND CURRENT ROW)g10
,SUM(g4)OVER(PARTITION BY trend,att11 ORDER BY ydate ROWS BETWEEN 12*22*30 PRECEDING AND CURRENT ROW)g11
,SUM(g4)OVER(PARTITION BY trend,att12 ORDER BY ydate ROWS BETWEEN 12*22*30 PRECEDING AND CURRENT ROW)g12
,SUM(g4)OVER(PARTITION BY trend,att13 ORDER BY ydate ROWS BETWEEN 12*22*30 PRECEDING AND CURRENT ROW)g13
,SUM(g4)OVER(PARTITION BY trend,att14 ORDER BY ydate ROWS BETWEEN 12*22*30 PRECEDING AND CURRENT ROW)g14
,SUM(g4)OVER(PARTITION BY trend,att15 ORDER BY ydate ROWS BETWEEN 12*22*30 PRECEDING AND CURRENT ROW)g15
,SUM(g4)OVER(PARTITION BY trend,att16 ORDER BY ydate ROWS BETWEEN 12*22*30 PRECEDING AND CURRENT ROW)g16
,SUM(g4)OVER(PARTITION BY trend,att17 ORDER BY ydate ROWS BETWEEN 12*22*30 PRECEDING AND CURRENT ROW)g17
,SUM(g4)OVER(PARTITION BY trend,att18 ORDER BY ydate ROWS BETWEEN 12*22*30 PRECEDING AND CURRENT ROW)g18
,SUM(g4)OVER(PARTITION BY trend,att19 ORDER BY ydate ROWS BETWEEN 12*22*30 PRECEDING AND CURRENT ROW)g19
,SUM(g4)OVER(PARTITION BY trend,att20 ORDER BY ydate ROWS BETWEEN 12*22*30 PRECEDING AND CURRENT ROW)g20
,SUM(g4)OVER(PARTITION BY trend,att21 ORDER BY ydate ROWS BETWEEN 12*22*30 PRECEDING AND CURRENT ROW)g21
,SUM(g4)OVER(PARTITION BY trend,att22 ORDER BY ydate ROWS BETWEEN 12*22*30 PRECEDING AND CURRENT ROW)g22
,SUM(g4)OVER(PARTITION BY trend,att23 ORDER BY ydate ROWS BETWEEN 12*22*30 PRECEDING AND CURRENT ROW)g23
,SUM(g4)OVER(PARTITION BY trend,att24 ORDER BY ydate ROWS BETWEEN 12*22*30 PRECEDING AND CURRENT ROW)g24
,SUM(g4)OVER(PARTITION BY trend,att25 ORDER BY ydate ROWS BETWEEN 12*22*30 PRECEDING AND CURRENT ROW)g25
,SUM(g4)OVER(PARTITION BY trend,att26 ORDER BY ydate ROWS BETWEEN 12*22*30 PRECEDING AND CURRENT ROW)g26
-- att26 is trend which is a powerful attribute so I derive 3 more goodness attributes from trend:
,SUM(g4)OVER(PARTITION BY trend,att26 ORDER BY ydate ROWS BETWEEN 12*40 PRECEDING AND CURRENT ROW)g27
,SUM(g4)OVER(PARTITION BY trend,att26 ORDER BY ydate ROWS BETWEEN 12*30 PRECEDING AND CURRENT ROW)g28
,SUM(g4)OVER(PARTITION BY trend,att26 ORDER BY ydate ROWS BETWEEN 12*20 PRECEDING AND CURRENT ROW)g29
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

SELECT
tkr
,COUNT(tkr)
,MIN(ydate),MAX(ydate)
FROM stk_ms
GROUP BY tkr
/

exit
