--
-- merge.sql
--

-- I use this script to merge data from ibs15min_stage into ibs15min.

-- Useful syntax for when things go haywire:
-- CREATE TABLE ibs15min         (tkr VARCHAR2(8),ydate DATE,clse NUMBER);
-- CREATE TABLE ibs15min_old     (tkr VARCHAR2(8),ydate DATE,clse NUMBER);
-- CREATE TABLE ibs15min_dups_old(tkr VARCHAR2(8),ydate DATE,clse NUMBER);

DROP TABLE ibs15min_old;
RENAME ibs15min TO ibs15min_old;

DROP TABLE ibs15min_dups_old;
RENAME ibs15min_dups TO ibs15min_dups_old;

CREATE TABLE ibs15min_dups COMPRESS AS
SELECT
tkr
,(TO_DATE('1970-01-01','YYYY-MM-DD')+(epochsec/24/3600))ydate
,clse
FROM ibs15min_stage
UNION
SELECT tkr,ydate,clse
FROM ibs15min_old
/

CREATE TABLE ibs15min COMPRESS AS
SELECT
tkr
,ydate
,AVG(clse)clse
FROM ibs15min_dups
GROUP BY tkr,ydate
/

ANALYZE TABLE ibs15min COMPUTE STATISTICS;

-- rpt

SELECT
tkr
,(sysdate - MAX(ydate))*24*60 minutes_age
,MIN(ydate)
,COUNT(ydate)
,MAX(ydate)
,MIN(clse)
,AVG(clse)
,MAX(clse)
FROM ibs15min
GROUP BY tkr
ORDER BY tkr
/

exit
