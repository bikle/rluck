
select
sysdate now
, TO_CHAR(sysdate,'D') ddy
,sysdate + 4/24 x4hr_from_now
,TRUNC(sysdate) + 21/24 + 50/60/24 ddline
,TRUNC(sysdate) + 3 + 9/24 + 11/60/24 mon_morn
,CASE WHEN
  (
  0+TO_CHAR((sysdate),'D') = 6
  AND
  sysdate+4 > TRUNC(sysdate) + 21/24 + 50/60/24
  )
  THEN'sell_mon1'
  WHEN 0+TO_CHAR((sysdate+4/24),'D') = 7
  THEN'sell_mon2'
ELSE'sell_in_4'END selltime
,CASE WHEN
  (
  0+TO_CHAR((sysdate),'D') = 6
  AND
  sysdate+4 > TRUNC(sysdate) + 21/24 + 50/60/24
  )
  THEN TRUNC(sysdate) + 3 + 9/24 + 11/60/24
  WHEN 0+TO_CHAR((sysdate+4/24),'D') = 7
  THEN TRUNC(sysdate) + 3 + 9/24 + 11/60/24
  ELSE sysdate + 4/24 END clsdate
from dual
/


SELECT
prdate
,CASE WHEN SUBSTR(prdate,1,3)='aud'THEN'aud_usd'
      WHEN SUBSTR(prdate,1,3)='eur'THEN'eur_usd'
      WHEN SUBSTR(prdate,1,3)='gbp'THEN'gbp_usd'
      WHEN SUBSTR(prdate,1,3)='cad'THEN'usd_cad'
      WHEN SUBSTR(prdate,1,3)='chf'THEN'usd_chf'
      WHEN SUBSTR(prdate,1,3)='jpy'THEN'usd_jpy'
  ELSE SUBSTR(prdate,1,3)
  END pair
,TO_DATE(SUBSTR(prdate,4,19))ydate
,'buy'         buysell
,score
,rundate
,sysdate       opdate

,CASE WHEN
  (
  0+TO_CHAR((sysdate),'D') = 6
  AND
  sysdate+4 > TRUNC(sysdate) + 21/24 + 50/60/24
  )
  THEN TRUNC(sysdate) + 3 + 9/24 + 11/60/24
  WHEN 0+TO_CHAR((sysdate+4/24),'D') = 7
  THEN TRUNC(sysdate) + 3 + 9/24 + 11/60/24
  ELSE sysdate + 4/24 END clsdate


FROM fxscores
WHERE score > 0.75
AND rundate > sysdate - 1/24
AND prdate NOT IN(SELECT prdate FROM oc)
ORDER BY rundate
/


SELECT
prdate
,CASE WHEN SUBSTR(prdate,1,3)='aud'THEN'aud_usd'
      WHEN SUBSTR(prdate,1,3)='eur'THEN'eur_usd'
      WHEN SUBSTR(prdate,1,3)='gbp'THEN'gbp_usd'
      WHEN SUBSTR(prdate,1,3)='cad'THEN'usd_cad'
      WHEN SUBSTR(prdate,1,3)='chf'THEN'usd_chf'
      WHEN SUBSTR(prdate,1,3)='jpy'THEN'usd_jpy'
  ELSE SUBSTR(prdate,1,3)
  END pair
,TO_DATE(SUBSTR(prdate,4,19))ydate
,'sell'         buysell
,score
,rundate
,sysdate       opdate
,CASE WHEN
  (
  0+TO_CHAR((sysdate),'D') = 6
  AND
  sysdate+4 > TRUNC(sysdate) + 21/24 + 50/60/24
  )
  THEN TRUNC(sysdate) + 3 + 9/24 + 11/60/24
  WHEN 0+TO_CHAR((sysdate+4/24),'D') = 7
  THEN TRUNC(sysdate) + 3 + 9/24 + 11/60/24
  ELSE sysdate + 4/24 END clsdate
FROM fxscores_gattn
WHERE score > 0.75
AND rundate > sysdate - 1/24
AND prdate NOT IN(SELECT prdate FROM oc)
ORDER BY rundate
/

