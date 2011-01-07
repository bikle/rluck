--
-- merge_dukas1hr_stk.sql
--

-- rpt

-- I should see some recent dates. Note that they are in VARCHAR2() format:
SELECT
MIN(ydate),MAX(ydate),
MIN(ttime),MAX(ttime)
FROM hstage
/

-- Look at them in DATE format.
SELECT 
COUNT(ydate),MIN(ydate),MAX(ydate)
FROM
  (
    SELECT
    TO_DATE(ydate||'_'||ttime,'MM/DD/YY_HH24:MI:SS')ydate
    FROM hstage
  )
/

-- DELETE contending records:
DELETE dukas1hr_stk 
WHERE UPPER(tkr) = UPPER('&1') AND ydate IN
  (
    SELECT 
    TO_DATE(ydate||'_'||ttime,'MM/DD/YY_HH24:MI:SS')ydate
    FROM hstage
  )
/

set lines 66
desc hstage
desc dukas1hr_stk
set lines 166

-- Do the merge here.
-- Assume the data in hstage is better than the data in dukas1hr_stk.
INSERT INTO dukas1hr_stk(tkr,ydate,clse)
  SELECT 
  UPPER('&1') tkr
  ,TO_DATE(ydate||'_'||ttime,'MM/DD/YY_HH24:MI:SS')ydate
  ,clse
  FROM hstage
/

-- I should get a perfect match here:
SELECT COUNT(ydate)FROM hstage;
SELECT COUNT(ydate)FROM dukas1hr_stk
WHERE UPPER(tkr) = UPPER('&1') AND ydate IN
  (SELECT 
   TO_DATE(ydate||'_'||ttime,'MM/DD/YY_HH24:MI:SS')ydate
   FROM hstage
  )
/

-- Here is where I remove obviously bad data:
DELETE dukas1hr_stk WHERE TRUNC(ydate) = '2010-11-18';

exit
