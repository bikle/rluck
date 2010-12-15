--
-- chf_build_scorem.sql
--

-- Builds a sql script to run a bunch of sql-scoring scripts.

SELECT '@chf_score1day.sql ',ydate FROM chf_ms14
WHERE 'chf'||ydate NOT IN (SELECT prdate FROM fxscores)
ORDER BY ydate
/

SELECT '@chf_score1day_gattn.sql ',ydate FROM chf_ms14
WHERE 'chf'||ydate NOT IN (SELECT prdate FROM fxscores_gattn)
ORDER BY ydate
/

