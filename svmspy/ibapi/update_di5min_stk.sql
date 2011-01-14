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
-- I want weekdays:
WHERE 0+TO_CHAR(ydate,'D')IN(2,3,4,5,6)
GROUP BY 
tkrdate
,tkr
,ydate
/

-- I need to shave a second off of some of the dates:

UPDATE di5min_stk SET ydate = ydate - 1/24/3600
WHERE TO_CHAR(ydate,'SS')='01'
/

SELECT COUNT(*)FROM di5min_stk;
SELECT COUNT(*)FROM di5min_stk WHERE TO_CHAR(ydate,'SS')='00';
SELECT COUNT(*)FROM di5min_stk WHERE TO_CHAR(ydate,'SS')='01';

UPDATE di5min_stk SET tkrdate = tkr||ydate;

-- Add a column to help join with future dates
-- and then calculate 1 day gain:
DROP TABLE   di5min_stk_fd;
CREATE TABLE di5min_stk_fd COMPRESS AS
SELECT
tkrdate
,tkr
,ydate
,clse
,CASE WHEN TO_CHAR(ydate,'dy')IN('mon','tue','wed','thu')THEN ydate+1
      WHEN TO_CHAR(ydate,'dy')IN('fri')THEN ydate+3
      ELSE NULL END selldate
FROM di5min_stk
/

-- Join with the future

DROP   TABLE di5min_stk_c2;

CREATE TABLE di5min_stk_c2 COMPRESS AS
SELECT
p.tkrdate
,p.tkr
,p.ydate
,p.clse
,p.selldate
,f.clse clse2
,f.clse - p.clse gain1day
FROM di5min_stk_fd p, di5min_stk f
-- Use a left-outer-join so I get recent rows in di5min_stk_fd:
WHERE p.tkr || p.selldate = f.tkrdate(+)
/

-- rpt
SELECT TO_CHAR(ydate,'dy')dday,COUNT(tkr) FROM di5min_stk_fd group by TO_CHAR(ydate,'dy');
SELECT TO_CHAR(ydate,'dy')dday,COUNT(tkr) FROM di5min_stk_c2 group by TO_CHAR(ydate,'dy');
SELECT MAX(ydate)FROM di5min_stk;
SELECT MAX(ydate)FROM di5min_stk_c2;

-- rpt
SELECT
tkr
,MIN(ydate)
,COUNT(ydate)
,MAX(ydate)
,MIN(clse)
,AVG(clse)
,MAX(clse)
,MAX(gain1day)
FROM di5min_stk_c2
GROUP BY tkr
ORDER BY tkr
/

COLUMN clse FORMAT 999.9999
SELECT
tkr
,ROUND(clse,4)clse
-- Should be NULL:
,ROUND(clse2,4)clse2
,ydate
FROM di5min_stk_c2
WHERE ydate > sysdate - 0.5/24
ORDER BY tkr,ydate
/
