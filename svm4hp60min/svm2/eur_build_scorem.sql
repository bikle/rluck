--
-- eur_build_scorem.sql
--

-- Builds a sql script to run a bunch of sql-scoring scripts.

SELECT '@eur_score1day.sql ',ydate FROM eur_ms14
WHERE 'eur'||ydate NOT IN (SELECT prdate FROM fxscores)
AND ydate > (SELECT MIN(ydate)+35 FROM eur_ms14)
ORDER BY ydate
/

SELECT '@eur_score1day_gattn.sql ',ydate FROM eur_ms14
WHERE 'eur'||ydate NOT IN (SELECT prdate FROM fxscores_gattn)
AND ydate > (SELECT MIN(ydate)+35 FROM eur_ms14)
ORDER BY ydate
/

