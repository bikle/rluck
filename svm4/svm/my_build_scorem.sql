--
-- my_build_scorem.sql
--

-- Builds a sql script to run a bunch of sql-scoring scripts.

SELECT '@aud_score1day.sql ',ydate FROM fxscores6
WHERE 'aud'||ydate NOT IN (SELECT prdate FROM fxscores4)
AND ydate > (SELECT MIN(ydate)+35 FROM aud_ms4)
ORDER BY DBMS_RANDOM.VALUE
/

SELECT '@aud_score1day_gattn.sql ',ydate FROM fxscores4_gattn
WHERE 'aud'||ydate NOT IN (SELECT prdate FROM fxscores4_gattn)
AND ydate > (SELECT MIN(ydate)+35 FROM aud_ms4)
ORDER BY DBMS_RANDOM.VALUE


