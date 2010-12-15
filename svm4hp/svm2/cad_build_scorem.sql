--
-- cad_build_scorem.sql
--

-- Builds a sql script to run a bunch of sql-scoring scripts.

SELECT '@cad_score1day.sql ',ydate FROM cad_ms14
WHERE 'cad'||ydate NOT IN (SELECT prdate FROM fxscores)
ORDER BY ydate
/

SELECT '@cad_score1day_gattn.sql ',ydate FROM cad_ms14
WHERE 'cad'||ydate NOT IN (SELECT prdate FROM fxscores_gattn)
ORDER BY ydate
/

