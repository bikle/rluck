--
-- jpy_build_scorem.sql
--

-- Builds a sql script to run a bunch of sql-scoring scripts.

SELECT '@jpy_score1day.sql ',ydate FROM jpy_ms6
WHERE 'jpy'||ydate NOT IN (SELECT prdate FROM fxscores6)
AND ydate > sysdate - 25/60/24
-- ORDER BY DBMS_RANDOM.VALUE
ORDER BY ydate
/

SELECT '@jpy_score1day_gattn.sql ',ydate FROM jpy_ms6
WHERE 'jpy'||ydate NOT IN (SELECT prdate FROM fxscores6_gattn)
AND ydate > sysdate - 25/60/24
-- ORDER BY DBMS_RANDOM.VALUE
ORDER BY ydate
/


