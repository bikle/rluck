--
-- update_di1hr_stk.sql
--

-- I use this script to keep di1hr_stk up to date.

-- This script is called from /pt/s/rluck/svmhstk/dl_then_svm.bash
-- After this script is called, I am then free to run SVM against the new data.

-- The table, di1hr_stk, contains data from duakas WHERE ydate < '2010-12-13 09:00:00'
-- Note that the dukas data is loaded from this dir:
-- /pt/s/rluck/svmhstk/dukas/
-- There, I use /pt/s/rluck/svmhstk/dukas/load_many.bash
-- to wrap /pt/s/rluck/svmhstk/dukas/load_tkr_1hr.bash

-- After '2010-12-13 09:00:00', di1hr_stk holds data from IB.

-- CREATE TABLE di1hr_stk0(tkrdate VARCHAR2(26),tkr VARCHAR2(7),ydate DATE,clse NUMBER);
-- CREATE TABLE di1hr_stk (tkrdate VARCHAR2(26),tkr VARCHAR2(7),ydate DATE,clse NUMBER);

TRUNCATE TABLE di1hr_stk0;
DROP TABLE di1hr_stk;
PURGE RECYCLEBIN;

-- Copy in data from ibs1hr:

INSERT INTO di1hr_stk0(tkrdate,tkr,ydate,clse)
SELECT         tkr||ydate,tkr,ydate,clse
FROM ibs1hr
WHERE ydate >= '2010-12-13 09:00:00'
/

-- rpt
SELECT
tkr
,MIN(ydate)
,COUNT(tkr)
,MAX(ydate)
FROM di1hr_stk0
GROUP BY tkr
ORDER BY tkr
/

-- Next, copy in data from dukas.

INSERT INTO di1hr_stk0(tkrdate,tkr,ydate,clse)
SELECT         tkr||ydate,tkr,ydate,clse
FROM dukas1hr_stk
WHERE ydate < '2010-12-13 09:00:00'
/

-- rpt
SELECT
tkr
,MIN(ydate)
,COUNT(tkr)
,MAX(ydate)
FROM dukas1hr_stk
WHERE ydate < '2010-12-13 09:00:00'
GROUP BY tkr
ORDER BY tkr
/

-- rpt
SELECT
tkr
,MIN(ydate)
,COUNT(tkr)
,MAX(ydate)
FROM di1hr_stk0
GROUP BY tkr
ORDER BY tkr
/

CREATE TABLE di1hr_stk COMPRESS AS
SELECT
tkrdate
,tkr
,ydate
,AVG(clse)clse
FROM di1hr_stk0
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
FROM di1hr_stk
GROUP BY tkr
ORDER BY tkr
/

COLUMN clse FORMAT 999.9999
SELECT
tkr
,ROUND(clse,4)clse
,ydate
FROM di1hr_stk
WHERE ydate > sysdate - 3/24
ORDER BY tkr,ydate
/
