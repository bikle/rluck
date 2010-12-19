--
-- abc_build_scorem.sql
--

-- Builds a sql script to run a bunch of sql-scoring scripts.

SELECT '@abc_score1day.sql ',ydate FROM abc_ms14
WHERE 'abc'||ydate NOT IN (SELECT prdate FROM fxscores8hp)
-- For backtesting:
AND ydate > (SELECT MIN(ydate)+35 FROM abc_ms14)
-- For cron:
AND ydate > sysdate - 15/60/24
ORDER BY ydate DESC
/

SELECT '@abc_score1day_gattn.sql ',ydate FROM abc_ms14
WHERE 'abc'||ydate NOT IN (SELECT prdate FROM fxscores8hp_gattn)
-- For backtesting:
AND ydate > (SELECT MIN(ydate)+35 FROM abc_ms14)
-- For cron:
AND ydate > sysdate - 15/60/24
ORDER BY ydate DESC
/

