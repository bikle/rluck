--
-- gbp_build_scorem.sql
--

-- Builds a sql script to run a bunch of sql-scoring scripts.

SELECT '@gbp_score1day.sql ',ydate FROM gbp_ms14
WHERE 'gbp'||ydate NOT IN (SELECT prdate FROM fxscores)
-- For backtesting:
AND ydate > (SELECT MIN(ydate)+35 FROM gbp_ms14)
-- For cron:
AND ydate > sysdate - 15/60/24
ORDER BY ydate
/

SELECT '@gbp_score1day_gattn.sql ',ydate FROM gbp_ms14
WHERE 'gbp'||ydate NOT IN (SELECT prdate FROM fxscores_gattn)
-- For backtesting:
AND ydate > (SELECT MIN(ydate)+35 FROM gbp_ms14)
-- For cron:
AND ydate > sysdate - 15/60/24
ORDER BY ydate
/

