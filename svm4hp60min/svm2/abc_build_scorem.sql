--
-- abc_build_scorem.sql
--

-- Builds a sql script to run a bunch of sql-scoring scripts.

SELECT '@abc_score1day.sql ',ydate FROM abc_ms14
WHERE 'abc'||ydate NOT IN (SELECT prdate FROM fxscores)
AND ydate > (SELECT MIN(ydate)+35 FROM abc_ms14)
ORDER BY ydate
/

SELECT '@abc_score1day_gattn.sql ',ydate FROM abc_ms14
WHERE 'abc'||ydate NOT IN (SELECT prdate FROM fxscores_gattn)
AND ydate > (SELECT MIN(ydate)+35 FROM abc_ms14)
ORDER BY ydate
/

