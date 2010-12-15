--
-- update_di5min.sql
--

-- I use this script to keep the di5min table up to date.

-- Currently I have access to data spread by 10 min.
-- After I collect data for 6 months, I will have data spread by 5 min.
-- At that time I will enhance this script (perhaps 2011-05-01).

-- CREATE TABLE di5min0(prdate VARCHAR2(26),pair VARCHAR2(7),ydate DATE,clse NUMBER);
-- CREATE TABLE di5min (prdate VARCHAR2(26),pair VARCHAR2(7),ydate DATE,clse NUMBER);

TRUNCATE TABLE di5min0;
DROP TABLE di5min;
PURGE RECYCLEBIN;

-- Copy in data from ibf5min:

INSERT INTO di5min0(prdate,pair,ydate,clse)
SELECT         pair||ydate,pair,ydate,clse
FROM ibf5min
-- I want every 10 min instead of every 5:
WHERE 0+TO_CHAR(ydate,'MI')IN(0,10,20,30,40,50)
AND ydate >= '2010-11-30'
/

-- rpt
SELECT
pair
,MIN(ydate)
,COUNT(pair)
,MAX(ydate)
FROM di5min0
GROUP BY pair
ORDER BY pair

-- Next, copy in data from dukas:

INSERT INTO di5min0(prdate,pair,ydate,clse)
SELECT         pair||ydate,pair,ydate,clse
FROM dukas10min
WHERE 0+TO_CHAR(ydate,'MI')IN(0,10,20,30,40,50)
AND ydate < '2010-11-30'
AND ydate > sysdate - 365 / 2
/

-- rpt
SELECT
pair
,MIN(ydate)
,COUNT(pair)
,MAX(ydate)
FROM dukas10min
GROUP BY pair
ORDER BY pair

-- rpt
SELECT
pair
,MIN(ydate)
,COUNT(pair)
,MAX(ydate)
FROM di5min0
GROUP BY pair
ORDER BY pair


-- Here is what I want:

CREATE TABLE di5min COMPRESS AS
SELECT
prdate
,pair
,ydate
,AVG(clse)clse
FROM di5min0
GROUP BY 
prdate
,pair
,ydate
ORDER BY 
prdate
,pair
,ydate
/

-- rpt
SELECT
pair
,MIN(ydate)
,COUNT(ydate)
,MAX(ydate)
,MIN(clse)
,AVG(clse)
,MAX(clse)
FROM di5min
GROUP BY pair
ORDER BY pair
/

COLUMN clse FORMAT 999.9999
SELECT
pair
,ROUND(clse,4)clse
,ydate
FROM di5min
WHERE ydate > sysdate - 3/24
ORDER BY pair,ydate
/