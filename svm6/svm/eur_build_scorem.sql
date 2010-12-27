--
-- eur_build_scorem.sql
--

-- Builds a sql script to run a bunch of sql-scoring scripts.

SELECT '@eur_score1day.sql ',ydate FROM eur_ms6
WHERE 'eur'||ydate NOT IN (SELECT prdate FROM fxscores6)
AND ydate > sysdate - 40/60/24
ORDER BY DBMS_RANDOM.VALUE
/

SELECT '@eur_score1day_gattn.sql ',ydate FROM eur_ms6
WHERE 'eur'||ydate NOT IN (SELECT prdate FROM fxscores6_gattn)
AND ydate > sysdate - 40/60/24
ORDER BY DBMS_RANDOM.VALUE
/


