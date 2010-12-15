--
-- jpy_build_scorem.sql
--

-- Builds a sql script to run a bunch of sql-scoring scripts.

SELECT '@jpy_score1day.sql ',ydate FROM jpy_ms14
WHERE 'jpy'||ydate NOT IN (SELECT prdate FROM fxscores)
-- For backtesting:
AND ydate > (SELECT MIN(ydate)+35 FROM jpy_ms14)
-- For cron:
-- AND ydate > sysdate - 0.5/24
ORDER BY ydate
/

SELECT '@jpy_score1day_gattn.sql ',ydate FROM jpy_ms14
WHERE 'jpy'||ydate NOT IN (SELECT prdate FROM fxscores_gattn)
-- For backtesting:
AND ydate > (SELECT MIN(ydate)+35 FROM jpy_ms14)
-- For cron:
-- AND ydate > sysdate - 0.5/24
ORDER BY ydate
/

