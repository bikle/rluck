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
      WHEN SUBSTR(prdate,1,3)='eur'THEN'eur_usd'
      WHEN SUBSTR(prdate,1,3)='gbp'THEN'gbp_usd'
      WHEN SUBSTR(prdate,1,3)='cad'THEN'usd_cad'
      WHEN SUBSTR(prdate,1,3)='chf'THEN'usd_chf'
      WHEN SUBSTR(prdate,1,3)='jpy'THEN'usd_jpy'
 ELSE SUBSTR(prdate,1,3)
 END pair
,TO_DATE(SUBSTR(prdate,4,19))ydate
,score
,rundate
FROM fxscores
WHERE score > 0.75
ORDER BY rundate
/

