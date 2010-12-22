--
-- order_by_random.sql
--

--
-- cad_build_scorem.sql
--

-- Builds a sql script to run a bunch of sql-scoring scripts.

SELECT '@cad_score1day.sql ',ydate FROM cad_ms14
WHERE 'cad'||ydate NOT IN (SELECT prdate FROM fxscores8hp)
-- For backtesting:
AND ydate > (SELECT MIN(ydate)+35 FROM cad_ms14)
AND ydate < '2010-12-17 12:00:00'
-- For cron:
-- AND ydate > sysdate - 15/60/24
ORDER BY DBMS_RANDOM.VALUE 
/