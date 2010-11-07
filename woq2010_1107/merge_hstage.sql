--
-- merge_hstage.sql
--

-- rpt

-- I should see some recent dates. Note that they are in VARCHAR2() format:
SELECT
MIN(ydate),MAX(ydate),
MIN(ttime),MAX(ttime)
FROM hstage
/

-- Look at them in DATE format.
-- Make use of ROUND(some_date,'HH24').
-- ROUND()-dates are easier to join between tables.
SELECT 
COUNT(ydate),MIN(ydate),MAX(ydate)
FROM
  (SELECT
  ROUND(TO_DATE(ydate||'_'||ttime,'MM/DD/YY_HH24:MI:SS'),'HH24')ydate
  FROM hstage)
/

-- DELETE contending records:
DELETE hourly 
WHERE pair=LOWER('&1')AND ROUND(ydate,'HH24') IN
  (SELECT 
   ROUND(TO_DATE(ydate||'_'||ttime,'MM/DD/YY_HH24:MI:SS'),'HH24')ydate
   FROM hstage
  )
/

set lines 66
desc hstage
desc hourly
set lines 166

-- Do the merge here.
-- Assume the data in hstage is better than the data in hourly.
INSERT INTO hourly(pair,ydate,vol,opn,clse,mn,mx)
  SELECT 
  LOWER('&1')pair
  ,ROUND(TO_DATE(ydate||'_'||ttime,'MM/DD/YY_HH24:MI:SS'),'HH24')ydate
  ,vol,opn,clse,mn,mx
  FROM hstage
/

-- I should get a perfect match here:
SELECT COUNT(ydate)FROM hstage;
SELECT COUNT(ydate)FROM hourly
WHERE pair=LOWER('&1')AND ROUND(ydate,'HH24') IN
  (SELECT 
   ROUND(TO_DATE(ydate||'_'||ttime,'MM/DD/YY_HH24:MI:SS'),'HH24')ydate
   FROM hstage
  )
/

exit
