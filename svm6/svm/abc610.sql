--
-- abc10.sql
--

-- Creates views and tables for backtesting a forex SVM strategy

PURGE RECYCLEBIN;

-- I created di5min here:
-- /pt/s/rlk/svm8hp/update_di5min.sql

CREATE OR REPLACE VIEW v10 AS
SELECT
pair
,ydate
,prdate
,rownum rnum -- acts as t in my time-series
,clse
,AVG(clse)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*6 PRECEDING AND CURRENT ROW)avg6
,LEAD(clse,12*6,NULL)OVER(PARTITION BY pair ORDER BY ydate)ld6
FROM di5min WHERE pair LIKE'%abc%'
ORDER BY ydate
/
