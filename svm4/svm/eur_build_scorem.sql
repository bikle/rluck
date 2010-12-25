--
-- eur_build_scorem.sql
--

-- Builds a sql script to run a bunch of sql-scoring scripts.

SELECT '@eur_score1day.sql ',ydate FROM eur_ms4
WHERE 'eur'||ydate NOT IN (SELECT prdate FROM fxscores4)
AND ydate > (SELECT MIN(ydate)+35 FROM eur_ms4)
ORDER BY DBMS_RANDOM.VALUE
/

SELECT '@eur_score1day_gattn.sql ',ydate FROM eur_ms4
WHERE 'eur'||ydate NOT IN (SELECT prdate FROM fxscores4_gattn)
AND ydate > (SELECT MIN(ydate)+35 FROM eur_ms4)
ORDER BY DBMS_RANDOM.VALUE
/

