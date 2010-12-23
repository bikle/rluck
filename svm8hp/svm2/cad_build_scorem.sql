--
-- cad_build_scorem.sql
--

-- Builds a sql script to run a bunch of sql-scoring scripts.

SELECT '@cad_score1day.sql ',ydate FROM cad_ms14
WHERE 'cad'||ydate NOT IN (SELECT prdate FROM fxscores8hp)
-- For backtesting:
AND ydate > (SELECT MIN(ydate)+35 FROM cad_ms14)
-- For cron:
AND ydate > sysdate - 30/60/24
ORDER BY ydate DESC
/

SELECT '@cad_score1day_gattn.sql ',ydate FROM cad_ms14
WHERE 'cad'||ydate NOT IN (SELECT prdate FROM fxscores8hp_gattn)
-- For backtesting:
AND ydate > (SELECT MIN(ydate)+35 FROM cad_ms14)
-- For cron:
AND ydate > sysdate - 30/60/24
ORDER BY ydate DESC
/

