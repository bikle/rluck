--
-- eur_build_scorem.sql
--

-- Builds a sql script to run a bunch of sql-scoring scripts.

SELECT '@eur_score1day.sql ',ydate FROM eur_ms14
WHERE 'eur'||ydate NOT IN (SELECT prdate FROM fxscores)
ORDER BY ydate
/

SELECT '@eur_score1day_gattn.sql ',ydate FROM eur_ms14
WHERE 'eur'||ydate NOT IN (SELECT prdate FROM fxscores_gattn)
ORDER BY ydate
/

