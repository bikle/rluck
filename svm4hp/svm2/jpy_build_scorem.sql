--
-- jpy_build_scorem.sql
--

-- Builds a sql script to run a bunch of sql-scoring scripts.

SELECT '@jpy_score1day.sql ',ydate FROM jpy_ms14
WHERE 'jpy'||ydate NOT IN (SELECT prdate FROM fxscores)
AND ydate > (SELECT MIN(ydate)+35 FROM jpy_ms14)
ORDER BY ydate
/

SELECT '@jpy_score1day_gattn.sql ',ydate FROM jpy_ms14
WHERE 'jpy'||ydate NOT IN (SELECT prdate FROM fxscores_gattn)
AND ydate > (SELECT MIN(ydate)+35 FROM jpy_ms14)
ORDER BY ydate
/

