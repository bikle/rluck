
SELECT count(ydate)
FROM jpy_ms14
WHERE 'jpy'||ydate NOT IN (SELECT prdate FROM fxscores8hp)
-- For backtesting:
AND ydate > (SELECT MIN(ydate)+35 FROM jpy_ms14)
-- For cron:
-- AND ydate > sysdate - 15/60/24
AND ydate > sysdate - 1
/

SELECT count(ydate)
FROM jpy_ms14
WHERE 'jpy'||ydate NOT IN (SELECT prdate FROM fxscores8hp_gattn)
-- For backtesting:
AND ydate > (SELECT MIN(ydate)+35 FROM jpy_ms14)
-- For cron:
-- AND ydate > sysdate - 15/60/24
AND ydate > sysdate - 1
/

