--
-- build_scorem.sql
--

-- Demo:
-- @build_scorem.sql SPY

-- I use this script to build another script full of calls to a set of
-- scoring scripts.

SELECT cmd,ydate,'&1' tkr FROM
(
SELECT '@score1_1hr.sql 'cmd,ydate FROM stk_ms
WHERE ydate NOT IN
  (SELECT ydate FROM stkscores_1hr WHERE targ='gatt'AND tkr='&1')
AND ydate > sysdate - 95
AND tkr = '&1'
UNION
SELECT '@score1_1hr_gattn.sql 'cmd,ydate FROM stk_ms
WHERE ydate NOT IN
  (SELECT ydate FROM stkscores_1hr WHERE targ='gattn'AND tkr='&1')
AND ydate > sysdate - 95
AND tkr = '&1'
)
ORDER BY DBMS_RANDOM.VALUE
-- ORDER BY ydate,cmd
/


