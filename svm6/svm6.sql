--
-- svm6.sql
--

CREATE OR REPLACE VIEW svm610 AS
SELECT
-- ydate is granular down to the hour:
ydate
,opn
-- 1st SVM attribute:
,0+TO_CHAR(ydate,'D') dow
-- 2nd SVM attribute:
,0+TO_CHAR(ydate,'HH24')hr
-- Get ydate 6 hours in the future:
,LEAD(ydate,6,NULL)OVER(ORDER BY ydate) ydate6
-- Get closing price 6 rows (usually 6 hours) in the future:
,LEAD(clse,5,NULL)OVER(ORDER BY ydate) clse6
FROM hourly 
WHERE ydate >'2009-01-01'
-- Prevent divide by zero:
AND opn > 0
-- Focus on aud_usd for now:
AND pair = 'aud_usd'
ORDER BY ydate
/

-- I derive more attributes:
CREATE OR REPLACE VIEW svm6ms AS
SELECT
ydate
,opn
,dow
,hr
,ydate6
,clse6
,(clse6 - opn)/opn npg
FROM svm610
ORDER BY ydate
/

--rpt
SELECT COUNT(ydate)FROM svm610;

SELECT COUNT(ydate),AVG(ydate6-ydate),MIN(ydate6-ydate),MAX(ydate6-ydate) FROM svm6ms;

-- I should see no rows WHERE the date difference is less than 6 hours:
SELECT COUNT(ydate)FROM svm6ms WHERE (ydate6 - ydate) < 6/24;

-- I should see many rows WHERE the date difference is exactly 6 hours:
SELECT COUNT(ydate)FROM svm6ms WHERE (ydate6 - ydate) = 6/24;

exit

