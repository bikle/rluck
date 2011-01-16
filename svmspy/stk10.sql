--
-- stk10.sql
--

-- Creates views and tables for demonstrating SVM.

DROP TABLE stk10svmspy;

PURGE RECYCLEBIN;

CREATE TABLE stk10svmspy COMPRESS AS
SELECT
tkr
,ydate
,tkr||ydate tkrdate
,clse
,clse2
,rownum rnum -- acts as t in my time-series
-- g1 is important. I want to predict g1:
,gain1day g1
-- Derive some attributes from clse.
-- Each row spans 5 minutes.
-- The number of rows in 1 day is 24*60/5.
-- I want the aggregations to span from 3 days to 9 days:
,MIN(clse)OVER(PARTITION BY tkr ORDER BY ydate ROWS BETWEEN 3*24*60/5 PRECEDING AND CURRENT ROW)min3
,MIN(clse)OVER(PARTITION BY tkr ORDER BY ydate ROWS BETWEEN 4*24*60/5 PRECEDING AND CURRENT ROW)min4
,MIN(clse)OVER(PARTITION BY tkr ORDER BY ydate ROWS BETWEEN 5*24*60/5 PRECEDING AND CURRENT ROW)min5
,MIN(clse)OVER(PARTITION BY tkr ORDER BY ydate ROWS BETWEEN 6*24*60/5 PRECEDING AND CURRENT ROW)min6
,MIN(clse)OVER(PARTITION BY tkr ORDER BY ydate ROWS BETWEEN 7*24*60/5 PRECEDING AND CURRENT ROW)min7
,MIN(clse)OVER(PARTITION BY tkr ORDER BY ydate ROWS BETWEEN 8*24*60/5 PRECEDING AND CURRENT ROW)min8
,MIN(clse)OVER(PARTITION BY tkr ORDER BY ydate ROWS BETWEEN 9*24*60/5 PRECEDING AND CURRENT ROW)min9
,AVG(clse)OVER(PARTITION BY tkr ORDER BY ydate ROWS BETWEEN 3*24*60/5 PRECEDING AND CURRENT ROW)avg3
,AVG(clse)OVER(PARTITION BY tkr ORDER BY ydate ROWS BETWEEN 4*24*60/5 PRECEDING AND CURRENT ROW)avg4
,AVG(clse)OVER(PARTITION BY tkr ORDER BY ydate ROWS BETWEEN 5*24*60/5 PRECEDING AND CURRENT ROW)avg5
,AVG(clse)OVER(PARTITION BY tkr ORDER BY ydate ROWS BETWEEN 6*24*60/5 PRECEDING AND CURRENT ROW)avg6
,AVG(clse)OVER(PARTITION BY tkr ORDER BY ydate ROWS BETWEEN 7*24*60/5 PRECEDING AND CURRENT ROW)avg7
,AVG(clse)OVER(PARTITION BY tkr ORDER BY ydate ROWS BETWEEN 8*24*60/5 PRECEDING AND CURRENT ROW)avg8
,AVG(clse)OVER(PARTITION BY tkr ORDER BY ydate ROWS BETWEEN 9*24*60/5 PRECEDING AND CURRENT ROW)avg9
,MAX(clse)OVER(PARTITION BY tkr ORDER BY ydate ROWS BETWEEN 3*24*60/5 PRECEDING AND CURRENT ROW)max3
,MAX(clse)OVER(PARTITION BY tkr ORDER BY ydate ROWS BETWEEN 4*24*60/5 PRECEDING AND CURRENT ROW)max4
,MAX(clse)OVER(PARTITION BY tkr ORDER BY ydate ROWS BETWEEN 5*24*60/5 PRECEDING AND CURRENT ROW)max5
,MAX(clse)OVER(PARTITION BY tkr ORDER BY ydate ROWS BETWEEN 6*24*60/5 PRECEDING AND CURRENT ROW)max6
,MAX(clse)OVER(PARTITION BY tkr ORDER BY ydate ROWS BETWEEN 7*24*60/5 PRECEDING AND CURRENT ROW)max7
,MAX(clse)OVER(PARTITION BY tkr ORDER BY ydate ROWS BETWEEN 8*24*60/5 PRECEDING AND CURRENT ROW)max8
,MAX(clse)OVER(PARTITION BY tkr ORDER BY ydate ROWS BETWEEN 9*24*60/5 PRECEDING AND CURRENT ROW)max9
FROM di5min_stk_c2
WHERE UPPER(tkr)='&1'
AND TO_CHAR(ydate,'dy')IN('mon','tue','wed','thu','fri')
AND 0+TO_CHAR(ydate,'HH24')BETWEEN 13 AND 20
ORDER BY ydate
/

ANALYZE TABLE stk10svmspy COMPUTE STATISTICS;

-- rpt

SELECT
tkr
,COUNT(tkr)ccount
,MIN(clse)mnclse,MAX(clse)mxclse
-- ,MIN(avg4),MAX(avg4)
,MIN(ydate),MAX(ydate)
,MIN(g1)
,MAX(g1)
FROM stk10svmspy
GROUP BY tkr
/

-- Derive trend, clse-relations, moving correlation of clse, and date related params:
DROP TABLE stk12svmspy;
CREATE TABLE stk12svmspy COMPRESS AS
SELECT
tkr
,ydate
,tkrdate
,clse
,rnum
,g1
,SIGN(avg4 - LAG(avg4,2,NULL)OVER(PARTITION BY tkr ORDER BY ydate))trend
-- I want more attributes from the ones I derived above:
-- clse relation to moving-min
,clse-min3  cm3
,clse-min4  cm4
,clse-min5  cm5
,clse-min6  cm6
,clse-min7  cm7
,clse-min8  cm8
,clse-min9  cm9
-- clse relation to moving-avg
,clse-avg3  ca3
,clse-avg4  ca4
,clse-avg5  ca5
,clse-avg6  ca6
,clse-avg7  ca7
,clse-avg8  ca8
,clse-avg9  ca9
-- clse relation to moving-max
,clse-max3  cx3
,clse-max4  cx4
,clse-max5  cx5
,clse-max6  cx6
,clse-max7  cx7
,clse-max8  cx8
,clse-max9  cx9
-- Derive date related attributes:
,0+TO_CHAR( ROUND(ydate,'HH24'),'HH24')hh
,0+TO_CHAR(ydate,'D')d
,0+TO_CHAR(ydate,'W')w
-- mpm stands for minutes-past-midnight:
,ROUND( (ydate - trunc(ydate))*24*60 )mpm
-- mph stands for minutes-past-hour:
,0+TO_CHAR(ydate,'MI')mph
FROM stk10svmspy
ORDER BY ydate
/

-- rpt

SELECT
tkr
,COUNT(tkr)ccount
,MIN(clse)mnclse,MAX(clse)mxclse
-- ,MIN(avg4),MAX(avg4)
,MIN(ydate),MAX(ydate)
,MIN(g1)
,AVG(g1)
,MAX(g1)
FROM stk12svmspy
GROUP BY tkr
/

-- Prepare for derivation of NTILE based parameters.
-- Also derive the "trend" parameter:

DROP TABLE stk14svmspy;
CREATE TABLE stk14svmspy COMPRESS AS
SELECT
tkr
,ydate
,tkrdate
,clse
,g1
,CASE WHEN g1 IS NULL THEN NULL WHEN g1/clse >  0.30/100 THEN 'up' ELSE 'nup' END gatt
,CASE WHEN g1 IS NULL THEN NULL WHEN g1/clse < -0.30/100 THEN 'up' ELSE 'nup' END gattn
,CASE WHEN trend IS NULL THEN 1
      WHEN trend =0      THEN 1
      ELSE trend END trend
,cm3
,cm4
,cm5
,cm6
,cm7
,cm8
,cm9
,ca3
,ca4
,ca5
,ca6
,ca7
,ca8
,ca9
,cx3
,cx4
,cx5
,cx6
,cx7
,cx8
,cx9
,hh
,d
,w
,mpm
,mph
FROM stk12svmspy
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
,AVG(g1)
FROM stk14svmspy
GROUP BY tkr,trend,gatt
ORDER BY tkr,trend,gatt
/

-- Derive NTILE based params:

DROP TABLE stk16svmspy;
CREATE TABLE stk16svmspy COMPRESS AS
SELECT
tkr
,ydate
,tkrdate
,clse
,g1
,gatt
,gattn
,trend
,NTILE(9)OVER(PARTITION BY trend,tkr ORDER BY cm3)att00
,NTILE(9)OVER(PARTITION BY trend,tkr ORDER BY cm4)att01
,NTILE(9)OVER(PARTITION BY trend,tkr ORDER BY cm5)att02
,NTILE(9)OVER(PARTITION BY trend,tkr ORDER BY cm6)att03
,NTILE(9)OVER(PARTITION BY trend,tkr ORDER BY cm7)att04
,NTILE(9)OVER(PARTITION BY trend,tkr ORDER BY cm8)att05
,NTILE(9)OVER(PARTITION BY trend,tkr ORDER BY cm9)att06
,NTILE(9)OVER(PARTITION BY trend,tkr ORDER BY ca3)att07
,NTILE(9)OVER(PARTITION BY trend,tkr ORDER BY ca4)att08
,NTILE(9)OVER(PARTITION BY trend,tkr ORDER BY ca5)att09
,NTILE(9)OVER(PARTITION BY trend,tkr ORDER BY ca6)att10
,NTILE(9)OVER(PARTITION BY trend,tkr ORDER BY ca7)att11
,NTILE(9)OVER(PARTITION BY trend,tkr ORDER BY ca8)att12
,NTILE(9)OVER(PARTITION BY trend,tkr ORDER BY ca9)att13
,NTILE(9)OVER(PARTITION BY trend,tkr ORDER BY cx3)att14
,NTILE(9)OVER(PARTITION BY trend,tkr ORDER BY cx4)att15
,NTILE(9)OVER(PARTITION BY trend,tkr ORDER BY cx5)att16
,NTILE(9)OVER(PARTITION BY trend,tkr ORDER BY cx6)att17
,NTILE(9)OVER(PARTITION BY trend,tkr ORDER BY cx7)att18
,NTILE(9)OVER(PARTITION BY trend,tkr ORDER BY cx8)att19
,NTILE(9)OVER(PARTITION BY trend,tkr ORDER BY cx9)att20
,hh  att21
,d   att22
,w   att23
,mpm att24
,mph att25
,trend att26
FROM stk14svmspy
ORDER BY ydate
/

-- rpt

SELECT
tkr
,trend
,gatt
,COUNT(tkr)
,AVG(g1)
FROM stk16svmspy
GROUP BY tkr,trend,gatt
ORDER BY tkr,trend,gatt
/

-- Now I derive goodness attributes:

DROP TABLE stk_ms_svmspy;
CREATE TABLE stk_ms_svmspy COMPRESS AS
SELECT
tkr
,ydate
,tkrdate
,trend
,g1
,gatt
,gattn
,SUM(g1)OVER(PARTITION BY trend,att00 ORDER BY ydate ROWS BETWEEN 90*24*60/5 PRECEDING AND CURRENT ROW)g00
,SUM(g1)OVER(PARTITION BY trend,att01 ORDER BY ydate ROWS BETWEEN 90*24*60/5 PRECEDING AND CURRENT ROW)g01
,SUM(g1)OVER(PARTITION BY trend,att02 ORDER BY ydate ROWS BETWEEN 90*24*60/5 PRECEDING AND CURRENT ROW)g02
,SUM(g1)OVER(PARTITION BY trend,att03 ORDER BY ydate ROWS BETWEEN 90*24*60/5 PRECEDING AND CURRENT ROW)g03
,SUM(g1)OVER(PARTITION BY trend,att04 ORDER BY ydate ROWS BETWEEN 90*24*60/5 PRECEDING AND CURRENT ROW)g04
,SUM(g1)OVER(PARTITION BY trend,att05 ORDER BY ydate ROWS BETWEEN 90*24*60/5 PRECEDING AND CURRENT ROW)g05
,SUM(g1)OVER(PARTITION BY trend,att06 ORDER BY ydate ROWS BETWEEN 90*24*60/5 PRECEDING AND CURRENT ROW)g06
,SUM(g1)OVER(PARTITION BY trend,att07 ORDER BY ydate ROWS BETWEEN 90*24*60/5 PRECEDING AND CURRENT ROW)g07
,SUM(g1)OVER(PARTITION BY trend,att08 ORDER BY ydate ROWS BETWEEN 90*24*60/5 PRECEDING AND CURRENT ROW)g08
,SUM(g1)OVER(PARTITION BY trend,att09 ORDER BY ydate ROWS BETWEEN 90*24*60/5 PRECEDING AND CURRENT ROW)g09
,SUM(g1)OVER(PARTITION BY trend,att10 ORDER BY ydate ROWS BETWEEN 90*24*60/5 PRECEDING AND CURRENT ROW)g10
,SUM(g1)OVER(PARTITION BY trend,att11 ORDER BY ydate ROWS BETWEEN 90*24*60/5 PRECEDING AND CURRENT ROW)g11
,SUM(g1)OVER(PARTITION BY trend,att12 ORDER BY ydate ROWS BETWEEN 90*24*60/5 PRECEDING AND CURRENT ROW)g12
,SUM(g1)OVER(PARTITION BY trend,att13 ORDER BY ydate ROWS BETWEEN 90*24*60/5 PRECEDING AND CURRENT ROW)g13
,SUM(g1)OVER(PARTITION BY trend,att14 ORDER BY ydate ROWS BETWEEN 90*24*60/5 PRECEDING AND CURRENT ROW)g14
,SUM(g1)OVER(PARTITION BY trend,att15 ORDER BY ydate ROWS BETWEEN 90*24*60/5 PRECEDING AND CURRENT ROW)g15
,SUM(g1)OVER(PARTITION BY trend,att16 ORDER BY ydate ROWS BETWEEN 90*24*60/5 PRECEDING AND CURRENT ROW)g16
,SUM(g1)OVER(PARTITION BY trend,att17 ORDER BY ydate ROWS BETWEEN 90*24*60/5 PRECEDING AND CURRENT ROW)g17
,SUM(g1)OVER(PARTITION BY trend,att18 ORDER BY ydate ROWS BETWEEN 90*24*60/5 PRECEDING AND CURRENT ROW)g18
,SUM(g1)OVER(PARTITION BY trend,att19 ORDER BY ydate ROWS BETWEEN 90*24*60/5 PRECEDING AND CURRENT ROW)g19
,SUM(g1)OVER(PARTITION BY trend,att20 ORDER BY ydate ROWS BETWEEN 90*24*60/5 PRECEDING AND CURRENT ROW)g20
,SUM(g1)OVER(PARTITION BY trend,att21 ORDER BY ydate ROWS BETWEEN 90*24*60/5 PRECEDING AND CURRENT ROW)g21
,SUM(g1)OVER(PARTITION BY trend,att22 ORDER BY ydate ROWS BETWEEN 90*24*60/5 PRECEDING AND CURRENT ROW)g22
,SUM(g1)OVER(PARTITION BY trend,att23 ORDER BY ydate ROWS BETWEEN 90*24*60/5 PRECEDING AND CURRENT ROW)g23
,SUM(g1)OVER(PARTITION BY trend,att24 ORDER BY ydate ROWS BETWEEN 90*24*60/5 PRECEDING AND CURRENT ROW)g24
,SUM(g1)OVER(PARTITION BY trend,att25 ORDER BY ydate ROWS BETWEEN 90*24*60/5 PRECEDING AND CURRENT ROW)g25
,SUM(g1)OVER(PARTITION BY trend,att26 ORDER BY ydate ROWS BETWEEN 90*24*60/5 PRECEDING AND CURRENT ROW)g26
-- att26 is trend which is a powerful attribute so I derive 3 more goodness attributes from trend:
,SUM(g1)OVER(PARTITION BY trend,att26 ORDER BY ydate ROWS BETWEEN 60*24*60/5 PRECEDING AND CURRENT ROW)g27
,SUM(g1)OVER(PARTITION BY trend,att26 ORDER BY ydate ROWS BETWEEN 30*24*60/5 PRECEDING AND CURRENT ROW)g28
,SUM(g1)OVER(PARTITION BY trend,att26 ORDER BY ydate ROWS BETWEEN 10*24*60/5 PRECEDING AND CURRENT ROW)g29
FROM stk16svmspy
/

-- rpt

SELECT
tkr
,trend
,gatt
,COUNT(tkr)
,AVG(g1)
FROM stk_ms_svmspy
GROUP BY tkr,trend,gatt
ORDER BY tkr,trend,gatt
/

SELECT
tkr
,0+TO_CHAR(ydate,'D')daynum
,COUNT(tkr)
,MIN(ydate),MAX(ydate)
FROM stk_ms_svmspy
GROUP BY tkr,0+TO_CHAR(ydate,'D')
ORDER BY tkr,0+TO_CHAR(ydate,'D')
/

-- exit
