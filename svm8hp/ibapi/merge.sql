--
-- merge.sql
--

-- I use this script to merge data from ibf_stage into ibf5min.


-- CREATE TABLE ibf_old     (pair VARCHAR2(8),ydate DATE,clse NUMBER);
-- CREATE TABLE ibf_dups_old(pair VARCHAR2(8),ydate DATE,clse NUMBER);

DROP TABLE ibf_old;
RENAME ibf5min TO ibf_old;

DROP TABLE ibf_dups_old;
RENAME ibf_dups TO ibf_dups_old;

CREATE TABLE ibf_dups COMPRESS AS
SELECT
pair
,(TO_DATE('1970-01-01','YYYY-MM-DD')+(epochsec/24/3600))ydate
,clse
FROM ibf_stage
UNION
SELECT pair,ydate,clse
FROM ibf_old
/

CREATE TABLE ibf5min COMPRESS AS
SELECT
pair
,ydate
,MAX(clse)clse
FROM ibf_dups
GROUP BY pair,ydate
/

-- I distrust the data before 2010-11-30
DELETE ibf5min WHERE ydate < '2010-11-30';

ANALYZE TABLE ibf5min COMPUTE STATISTICS;

-- I should see less than 60 min:
SELECT
pair
,(sysdate - MAX(ydate))*24*60 minutes_age
,MIN(ydate)
,COUNT(ydate)
,MAX(ydate)FROM
ibf5min
GROUP BY pair
/

exit
