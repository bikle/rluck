--
-- oc.sql
--

-- This script helps me open and close forex positions.

INSERT INTO oc(prdate,pair,ydate,buysell,score,rundate,opdate,clsdate)

COLUMN prdate FORMAT A22

SELECT
prdate
,SUBSTR(prdate,1,3)pair
,CASE WHEN SUBSTR(prdate,1,3)='aud'THEN'aud_usd'
 ELSE SUBSTR(prdate,1,3)
 END pair
,TO_DATE(SUBSTR(prdate,4,19))ydate
,score
,rundate
FROM fxscores
WHERE score > 0.75
ORDER BY rundate
/

