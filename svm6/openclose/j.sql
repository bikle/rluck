--
-- ocj.sql
--

-- This script helps me open and close forex positions.
-- Typically this script is called from oc.rb
-- The script oc.rb uses a bit of logic to determine which cmd-line-args
-- to supply to this script.

-- Demo:
-- sqt @oc.sql aud 0.75  1.0 1.0 0.0416

-- 1st cmd-line-arg is a 3 letter code for pair: aud, eur, gbp, cad, chf, jpy, ech
-- 2nd cmd-line-arg constrains the 1st INSERT
-- 3rd cmd-line-arg constrains the 2nd INSERT
-- 4th cmd-line-arg constrains the 1st INSERT
-- 5th cmd-line-arg constrains the 2nd INSERT


CREATE OR REPLACE VIEW ocj AS
SELECT
s.prdate
,s.score
,s.rundate
,s.pair
,s.ydate
,g.score gscore
FROM fxscores6 s,fxscores6_gattn g
WHERE s.prdate = g.prdate
/


INSERT INTO oc(prdate,pair,ydate,buysell,score,rundate,opdate,clsdate)
SELECT
prdate
,CASE WHEN SUBSTR(prdate,1,3)='aud'THEN'aud_usd'
      WHEN SUBSTR(prdate,1,3)='eur'THEN'eur_usd'
      WHEN SUBSTR(prdate,1,3)='gbp'THEN'gbp_usd'
      WHEN SUBSTR(prdate,1,3)='cad'THEN'usd_cad'
      WHEN SUBSTR(prdate,1,3)='chf'THEN'usd_chf'
      WHEN SUBSTR(prdate,1,3)='jpy'THEN'usd_jpy'
  ELSE SUBSTR(prdate,1,3)
  END    pair
,TO_DATE(SUBSTR(prdate,4,19))ydate
,'buy'   buysell
,score
,rundate
,sysdate opdate
-- Deal with Fri-afternoon.
-- I want to close Late-Fri-afternoon orders on Mon Morn 01:11 GMT
-- This is 09:11am in Tokyo:
,CASE WHEN
  (
  0+TO_CHAR((sysdate),'D') = 6
  AND
  sysdate+6/24 > TRUNC(sysdate) + 21/24 + 50/60/24
  )
  THEN TRUNC(sysdate) + 3 + 1/24 + 11/60/24
  WHEN 0+TO_CHAR((sysdate+6/24),'D') = 7
  THEN TRUNC(sysdate) + 2 + 1/24 + 11/60/24
  ELSE sysdate + 6/24 END clsdate
-- FROM fxscores6
FROM ocj
-- The 2nd param corresponds to score_floor_long in oc.rb:
WHERE score > '&2'
AND gscore < 0.25
-- The 1st param corresponds to pairname in oc.rb:
AND pair = '&1'
AND rundate > sysdate - 11/60/24
AND prdate NOT IN(SELECT prdate FROM oc)
-- Avoid entering too many orders close together:
AND sysdate - '&4' >
  (SELECT MAX(opdate)FROM oc WHERE pair='&1'AND buysell='buy')
ORDER BY rundate
/

exit