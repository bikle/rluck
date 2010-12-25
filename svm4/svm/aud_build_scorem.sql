--
-- aud_build_scorem.sql
--

-- Builds a sql script to run a bunch of sql-scoring scripts.

SELECT '@aud_score1day.sql ',ydate FROM aud_ms6
WHERE 'aud'||ydate NOT IN (SELECT prdate FROM fxscores6)
AND ydate > (SELECT MIN(ydate)+35 FROM aud_ms6)
ORDER BY DBMS_RANDOM.VALUE
/

SELECT '@aud_score1day_gattn.sql ',ydate FROM aud_ms6
WHERE 'aud'||ydate NOT IN (SELECT prdate FROM fxscores6_gattn)
AND ydate > (SELECT MIN(ydate)+35 FROM aud_ms6)
ORDER BY DBMS_RANDOM.VALUE
/

