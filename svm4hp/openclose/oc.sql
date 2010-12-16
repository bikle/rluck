--
-- oc.sql
--

-- This script helps me open and close forex positions.

INSERT INTO oc(prdate,pair,ydate,buysell,score,rundate,opdate,clsdate)

SELECT
prdate
,score
,rundate
FROM fxscores
WHERE score > 0.75
ORDER BY rundate
/

