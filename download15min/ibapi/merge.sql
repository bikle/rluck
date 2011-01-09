--
-- merge.sql
--

-- I use this script to merge data from ibs_stage into ibs15min.


-- CREATE TABLE ibs_old     (tkr VARCHAR2(8),ydate DATE,clse NUMBER);
-- CREATE TABLE ibs_dups_old(tkr VARCHAR2(8),ydate DATE,clse NUMBER);

DROP TABLE ibs_old;
RENAME ibs15min TO ibs_old;

DROP TABLE ibs_dups_old;
RENAME ibs_dups TO ibs_dups_old;

CREATE TABLE ibs_dups COMPRESS AS
SELECT
tkr
,(TO_DATE('1970-01-01','YYYY-MM-DD')+(epochsec/24/3600))ydate
,clse
FROM ibs_stage
UNION
SELECT tkr,ydate,clse
FROM ibs_old
/

CREATE TABLE ibs15min COMPRESS AS
SELECT
tkr
,ydate
,AVG(clse)clse
FROM ibs_dups
GROUP BY tkr,ydate
/

ANALYZE TABLE ibs15min COMPUTE STATISTICS;

-- rpt

SELECT
tkr
,(sysdate - MAX(ydate))*24*60 minutes_age
,MIN(ydate)
,COUNT(ydate)
,MAX(ydate)FROM
ibs15min
GROUP BY tkr
/

exit