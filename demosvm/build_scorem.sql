--
-- build_scorem.sql
--

-- I use this script to build another script full of calls to a set of
-- scoring scripts.

SELECT cmd,ydate FROM
(
SELECT '@score1_5min.sql 'cmd,ydate FROM jpy_ms
WHERE ydate NOT IN (SELECT ydate FROM fxscores_demo)
AND ydate > sysdate - 11
UNION
SELECT '@score1_5min_gattn.sql 'cmd,ydate FROM jpy_ms
WHERE ydate NOT IN (SELECT ydate FROM fxscores_demo_gattn)
AND ydate > sysdate - 11
)
ORDER BY ydate,cmd
/


