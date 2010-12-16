--
-- oc.sql
--

-- This script helps me open and close forex positions.

INSERT INTO oc(pair,buysell,score,score2,trend,ydate,rundate,opdate,clsdate)

SELECT
prdate
,score
,rundate
FROM fxscores
WHERE score > 0.75
ORDER BY rundate
/

