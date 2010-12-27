--
-- abc_build_scorem.sql
--

-- Builds a sql script to run a bunch of sql-scoring scripts.

SELECT '@abc_score1day.sql ',ydate FROM abc_ms6
WHERE 'abc'||ydate NOT IN (SELECT prdate FROM fxscores6)
AND ydate > sysdate - 40/60/24
ORDER BY DBMS_RANDOM.VALUE
/

SELECT '@abc_score1day_gattn.sql ',ydate FROM abc_ms6
WHERE 'abc'||ydate NOT IN (SELECT prdate FROM fxscores6_gattn)
AND ydate > sysdate - 40/60/24
ORDER BY DBMS_RANDOM.VALUE
/


