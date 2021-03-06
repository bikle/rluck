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
WHERE ydate > '2011-03-01'
AND tkr = '&1'
AND tkrdate NOT IN(SELECT tkrdate FROM stkscores WHERE targ='gatt'AND tkr = '&1')
UNION
SELECT '@score1_5min_gattn.sql 'cmd,ydate FROM stk_ms_u
WHERE ydate > '2011-03-01'
AND tkr = '&1'
AND tkrdate NOT IN(SELECT tkrdate FROM stkscores WHERE targ='gatt'AND tkr = '&1')
)
-- ORDER BY DBMS_RANDOM.VALUE
-- WHERE ydate >= '2011-05-19 19:30:00'
-- WHERE ydate BETWEEN'2011-03-14'AND'2011-04-01'
-- WHERE ydate > sysdate - 2/24
WHERE ydate > '2011-04-11'
ORDER BY ydate,cmd
/


