--
-- update_ibfu_t.sql
--

-- I use this script to keep ibfu_t up to date.

-- ibfu_t looks like this:
-- 
-- 08:36:13 SQL> desc ibfu_t
--  Name                             Null?    Type
--  -------------------------------- -------- -----------------------
--  PRDATE                                    VARCHAR2(26)
--  PAIR                                      VARCHAR2(7)
--  YDATE                                     DATE
--  CLSE                                      NUMBER
-- 
-- 08:36:17 SQL> 

-- CREATE TABLE ibfu_t0(prdate VARCHAR2(26),pair VARCHAR2(7),ydate DATE,clse NUMBER);
-- CREATE TABLE ibfu_t(prdate VARCHAR2(26),pair VARCHAR2(7),ydate DATE,clse NUMBER);

TRUNCATE TABLE ibfu_t0;
DROP TABLE ibfu_t;
PURGE RECYCLEBIN;

-- Copy in data from ibf15min which has the data I like the most:

INSERT INTO ibfu_t0(prdate       ,pair,      ydate,        clse)
SELECT  pair||ROUND(ydate,'HH24'),pair,ROUND(ydate,'HH24'),clse
FROM ibf15min
WHERE ABS(ydate-ROUND(ydate,'HH24'))<=5/60/24
/

-- Copy in data from ibf5min:

INSERT INTO ibfu_t0(prdate       ,pair,      ydate,        clse)
SELECT  pair||ROUND(ydate,'HH24'),pair,ROUND(ydate,'HH24'),clse
FROM ibf5min
WHERE ABS(ydate-ROUND(ydate,'HH24'))<5/60/24
AND pair||ROUND(ydate,'HH24')NOT IN
  (SELECT prdate FROM ibfu_t0)
/

-- Next, copy in hourly data from dukas:

INSERT INTO ibfu_t0(prdate       ,pair,      ydate,        clse)
SELECT  pair||ROUND(ydate,'HH24'),pair,ROUND(ydate,'HH24'),clse
FROM hourly
WHERE ABS(ydate-ROUND(ydate,'HH24'))<=5/60/24
AND ydate > sysdate - 365/2 - 35
AND pair||ROUND(ydate,'HH24')NOT IN
  (SELECT prdate FROM ibfu_t0)
/

-- Double check that it is really clean:

DELETE ibfu_t0 WHERE ABS(ydate-ROUND(ydate,'HH24'))>5/60/24;
UPDATE ibfu_t0 SET ydate  = ROUND(ydate,'HH24');
UPDATE ibfu_t0 SET prdate = pair||ydate;

-- Here is what I want:

CREATE TABLE ibfu_t COMPRESS AS
SELECT
prdate
,pair
,ydate
,AVG(clse)clse
FROM ibfu_t0
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
FROM ibfu_t
GROUP BY pair
ORDER BY pair
/

SELECT
pair
,ROUND(clse,4)clse
,ydate
FROM ibfu_t
WHERE ydate > sysdate - 1.1
ORDER BY pair,ydate
/
