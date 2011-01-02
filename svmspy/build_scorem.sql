--
-- build_scorem.sql
--

-- I use this script to build another script full of calls to a set of
-- scoring scripts.

SELECT cmd,ydate FROM
(
SELECT '@score1_5min.sql 'cmd,ydate FROM stk_ms
WHERE ydate NOT IN (SELECT ydate FROM stkscores WHERE targ='gatt')
AND ydate > sysdate - 11
UNION
SELECT '@score1_5min_gattn.sql 'cmd,ydate FROM stk_ms
WHERE ydate NOT IN (SELECT ydate FROM stkscores WHERE targ='gattn')
AND ydate > sysdate - 11
)
ORDER BY ydate,cmd
/


