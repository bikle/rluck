--
-- merge.sql
--

-- I use this script to merge data from ibs_stage into ibs5min.


-- CREATE TABLE ibs_old     (tkr VARCHAR2(8),ydate DATE,clse NUMBER);
-- CREATE TABLE ibs_dups_old(tkr VARCHAR2(8),ydate DATE,clse NUMBER);

DROP TABLE ibs_old;
RENAME ibs5min TO ibs_old;

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

-- ibs_stage may have data outside of RTH.
-- Remove data which is outside of RTH:
DELETE ibs_dups WHERE TO_CHAR(ydate,'HH24:MI') < '14:30'AND ydate < '2011-03-14';
DELETE ibs_dups WHERE TO_CHAR(ydate,'HH24:MI') > '20:55'AND ydate < '2011-03-14';
-- Daylight savings time started on 2011-03-14:	                                                                        
DELETE ibs_dups WHERE TO_CHAR(ydate,'HH24:MI') < '13:30'AND ydate > '2011-03-14';
DELETE ibs_dups WHERE TO_CHAR(ydate,'HH24:MI') > '19:55'AND ydate > '2011-03-14';

CREATE TABLE ibs5min COMPRESS AS
SELECT
tkr
,ydate
,AVG(clse)clse
FROM ibs_dups
GROUP BY tkr,ydate
/

ANALYZE TABLE ibs5min ESTIMATE STATISTICS SAMPLE 9 PERCENT;

-- I should see less than 60 min:
SELECT
tkr
,(sysdate - MAX(ydate))*24*60 minutes_age
,MIN(ydate)
,COUNT(ydate)
,MAX(ydate)
,MIN(clse)
,AVG(clse)
,MAX(clse)
FROM
ibs5min
GROUP BY tkr
ORDER BY tkr
/

exit
