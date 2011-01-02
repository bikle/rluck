--
-- score1_5min_gattn.sql
--

CREATE OR REPLACE VIEW sme AS
SELECT
prdate
,NULL gattn
,g00
,g01
,g02
,g03
,g04
,g05
,g06
,g07
,g08
FROM stk_ms
WHERE ydate = '&1'||' '||'&2'
/

-- rpt
-- We should see just 1 row:

SELECT COUNT(prdate) FROM sme;

-- Build the model:
CREATE OR REPLACE VIEW bme AS
SELECT
prdate
,gattn
,g00
,g01
,g02
,g03
,g04
,g05
,g06
,g07
,g08
FROM stk_ms
WHERE gattn IN('nup','up')
-- Use only rows which are older than 1 day:
AND 1+ydate < '&1'||' '||'&2'
/

-- rpt

SELECT gattn, COUNT(prdate) FROM bme GROUP BY gattn;

SELECT MAX(prdate) FROM bme;

-- Now build model from bme and score sme
-- @score1gattn.sql
