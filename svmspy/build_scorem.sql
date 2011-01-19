--
-- build_scorem.sql
--

-- Demo:
-- @build_scorem.sql SPY

-- I use this script to build another script full of calls to a set of
-- scoring scripts.

SELECT cmd,ydate,'&1' tkr FROM
(
SELECT '@score1_5min.sql 'cmd,ydate FROM stk_ms_u
WHERE ydate NOT IN
  (SELECT ydate FROM stkscores WHERE targ='gatt'AND tkr='&1')
AND ydate > '2010-12-01'
AND ydate > sysdate - 4
-- AND ydate > sysdate - 0.5/24
AND tkr = '&1'
UNION
SELECT '@score1_5min_gattn.sql 'cmd,ydate FROM stk_ms_u
WHERE ydate NOT IN
  (SELECT ydate FROM stkscores WHERE targ='gattn'AND tkr='&1')
AND ydate > '2010-12-01'
AND ydate > sysdate - 4
-- AND ydate > sysdate - 0.5/24
AND tkr = '&1'
)
-- ORDER BY DBMS_RANDOM.VALUE
ORDER BY ydate,cmd
/


