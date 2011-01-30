--
-- build_scorem.sql
--

-- Demo:
-- @build_scorem.sql aud_usd

-- I use this script to build another script full of calls to a set of
-- scoring scripts.

SELECT cmd,ydate,'&1' pair FROM
(
SELECT '@score1_5min.sql 'cmd,ydate FROM modsrc24
WHERE ydate NOT IN
  (SELECT ydate FROM svm24scores WHERE targ='gatt'AND pair='&1')
AND ydate > sysdate - 11
AND pair = '&1'
UNION
SELECT '@score1_5min_gattn.sql 'cmd,ydate FROM modsrc24
WHERE ydate NOT IN
  (SELECT ydate FROM svm24scores WHERE targ='gattn'AND pair='&1')
AND ydate > sysdate - 11
AND pair = '&1'
)
ORDER BY DBMS_RANDOM.VALUE
-- ORDER BY ydate,cmd
/

