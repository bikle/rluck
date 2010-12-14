--
-- abc_build_scorem.sql
--

-- Builds a sql script to run a bunch of sql-scoring scripts.
-- No longer Use NOT IN to filter out scripts which we already ran.

SELECT '@abc_score1day.sql ',ydate FROM abc_ms14
WHERE ydate > '2010-11-10 04:00:00'
AND 'abc'||ydate NOT IN (SELECT prdate FROM fxscores where score2 > 0)
ORDER BY ydate
/

SELECT '@abc_score1day_gattn.sql ',ydate FROM abc_ms14
WHERE ydate > '2010-11-10 04:00:00'
AND 'abc'||ydate NOT IN (SELECT prdate FROM fxscores_gattn where score2 > 0)
ORDER BY ydate
/
