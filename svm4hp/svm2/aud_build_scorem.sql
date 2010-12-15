--
-- aud_build_scorem.sql
--

-- Builds a sql script to run a bunch of sql-scoring scripts.

SELECT '@aud_score1day.sql ',ydate FROM aud_ms14
WHERE 'aud'||ydate NOT IN (SELECT prdate FROM fxscores)
ORDER BY ydate
/

SELECT '@aud_score1day_gattn.sql ',ydate FROM aud_ms14
WHERE 'aud'||ydate NOT IN (SELECT prdate FROM fxscores_gattn)
ORDER BY ydate
/

