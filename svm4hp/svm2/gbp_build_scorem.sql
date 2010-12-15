--
-- gbp_build_scorem.sql
--

-- Builds a sql script to run a bunch of sql-scoring scripts.

SELECT '@gbp_score1day.sql ',ydate FROM gbp_ms14
WHERE 'gbp'||ydate NOT IN (SELECT prdate FROM fxscores)
AND ydate > (SELECT MIN(ydate)+35 FROM gbp_ms14)
ORDER BY ydate
/

SELECT '@gbp_score1day_gattn.sql ',ydate FROM gbp_ms14
WHERE 'gbp'||ydate NOT IN (SELECT prdate FROM fxscores_gattn)
AND ydate > (SELECT MIN(ydate)+35 FROM gbp_ms14)
ORDER BY ydate
/

