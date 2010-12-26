--
-- jpy_build_scorem.sql
--

-- Builds a sql script to run a bunch of sql-scoring scripts.

SELECT '@jpy_score1day.sql ',ydate FROM jpy_ms6
WHERE 'jpy'||ydate NOT IN (SELECT prdate FROM fxscores6)
AND ydate > (SELECT MIN(ydate)+35 FROM jpy_ms6)
AND ydate BETWEEN'2010-12-19'AND'2010-12-25'
ORDER BY DBMS_RANDOM.VALUE
/

SELECT '@jpy_score1day_gattn.sql ',ydate FROM jpy_ms6
WHERE 'jpy'||ydate NOT IN (SELECT prdate FROM fxscores6_gattn)
AND ydate > (SELECT MIN(ydate)+35 FROM jpy_ms6)
AND ydate BETWEEN'2010-12-19'AND'2010-12-25'
ORDER BY DBMS_RANDOM.VALUE
/


