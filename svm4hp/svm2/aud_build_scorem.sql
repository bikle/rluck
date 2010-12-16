--
-- aud_build_scorem.sql
--

-- Builds a sql script to run a bunch of sql-scoring scripts.

SELECT '@aud_score1day.sql ',ydate FROM aud_ms14
WHERE 'aud'||ydate NOT IN (SELECT prdate FROM fxscores)
-- For backtesting:
AND ydate > (SELECT MIN(ydate)+35 FROM aud_ms14)
-- For cron:
AND ydate > sysdate - 11/60/24
ORDER BY ydate
/

SELECT '@aud_score1day_gattn.sql ',ydate FROM aud_ms14
WHERE 'aud'||ydate NOT IN (SELECT prdate FROM fxscores_gattn)
-- For backtesting:
AND ydate > (SELECT MIN(ydate)+35 FROM aud_ms14)
-- For cron:
AND ydate > sysdate - 11/60/24
ORDER BY ydate
/

