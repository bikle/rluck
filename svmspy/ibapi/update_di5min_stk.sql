--
-- update_di5min_stk.sql
--

-- I use this script to keep di5min_stk up to date.

-- The table, di5min_stk, contains data from duakas before '2010-12-27 09:00:00'
-- After that date, it holds data from IB.

-- CREATE TABLE di5min_stk0(tkrdate VARCHAR2(26),tkr VARCHAR2(7),ydate DATE,clse NUMBER);
-- CREATE TABLE di5min_stk (tkrdate VARCHAR2(26),tkr VARCHAR2(7),ydate DATE,clse NUMBER);

TRUNCATE TABLE di5min_stk0;
DROP TABLE di5min_stk;
PURGE RECYCLEBIN;

-- Copy in data from ibs5min:

INSERT INTO di5min_stk0(tkrdate,tkr,ydate,clse)
SELECT         tkr||ydate,tkr,ydate,clse
FROM ibs5min
WHERE ydate >= '2010-12-27 09:00:00'
/

-- rpt
SELECT
tkr
,MIN(ydate)
,COUNT(tkr)
,MAX(ydate)
FROM di5min_stk0
GROUP BY tkr
ORDER BY tkr
/

-- Next, copy in data from dukas.
-- dukas5min_stk depends on:
-- - dukas10min_stk
-- - svmspy/dukas/fake5.sql

INSERT INTO di5min_stk0(tkrdate,tkr,ydate,clse)
SELECT         tkr||ydate,tkr,ydate,clse
FROM dukas5min_stk
WHERE ydate < '2010-12-27 09:00:00'
/

-- rpt
SELECT
tkr
,MIN(ydate)
,COUNT(tkr)
,MAX(ydate)
FROM dukas5min_stk
WHERE ydate < '2010-12-27 09:00:00'
GROUP BY tkr
ORDER BY tkr
/

-- rpt
SELECT
tkr
,MIN(ydate)
,COUNT(tkr)
,MAX(ydate)
FROM di5min_stk0
GROUP BY tkr
ORDER BY tkr
/

CREATE TABLE di5min_stk COMPRESS AS
SELECT
tkrdate
,tkr
,ydate
,AVG(clse)clse
FROM di5min_stk0
GROUP BY 
tkrdate
,tkr
,ydate
/

-- rpt
SELECT
tkr
,MIN(ydate)
,COUNT(ydate)
,MAX(ydate)
,MIN(clse)
,AVG(clse)
,MAX(clse)
FROM di5min_stk
GROUP BY tkr
ORDER BY tkr
/

COLUMN clse FORMAT 999.9999
SELECT
tkr
,ROUND(clse,4)clse
,ydate
FROM di5min_stk
WHERE ydate > sysdate - 3/24
ORDER BY tkr,ydate
/
