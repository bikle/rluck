--
-- svm6.sql
--

CREATE OR REPLACE VIEW svm610 AS
SELECT
pair
-- ydate is granular down to the hour:
,ydate
,opn
,TO_CHAR(ydate,'D') dow
,TO_CHAR(ydate,'HH24')hr
-- Get ydate 6 hours in the future:
,LEAD(ydate,6,NULL)OVER(PARTITION BY pair ORDER BY pair,ydate) ydate6
-- Get closing price 6 hours in the future:
,LEAD(clse,5,NULL)OVER(PARTITION BY pair ORDER BY pair,ydate) clse6
-- Derive my 1st SVM attribute, hsince:
,(ydate - TO_DATE('2000-01-01','YYYY-MM-DD'))*24 hsince
FROM hourly 
WHERE ydate > '2009-01-01'
-- Prevent divide by zero:
AND opn > 0
ORDER BY pair,ydate
/

-- I derive more attributes:
CREATE OR REPLACE VIEW svm612 AS
SELECT
pair
,ydate
,opn
,dow
,hr
,ydate6
,clse6
,hsince
,(clse6 - opn)/opn npg
FROM svm610
ORDER BY pair,ydate
/

--rpt
SELECT COUNT(ydate)FROM svm610;

SELECT COUNT(ydate),AVG(ydate6-ydate),MIN(ydate6-ydate),MAX(ydate6-ydate),MIN(hsince),AVG(hsince),MAX(hsince) FROM svm612;

exit

-- I should see no rows WHERE the date difference is less than 6 hours:
SELECT COUNT(ydate)FROM svm612 WHERE (ydate6 - ydate) < 6/24;

-- I should see many rows WHERE the date difference is exactly 6 hours:
SELECT COUNT(ydate)FROM svm612 WHERE (ydate6 - ydate) = 6/24;

exit

