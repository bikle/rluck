--
-- score1_5min.sql
--

CREATE OR REPLACE VIEW sme AS
SELECT
tkrdate
,NULL gatt
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

SELECT COUNT(tkrdate) FROM sme;

-- Build the model:
CREATE OR REPLACE VIEW bme AS
SELECT
tkrdate
,gatt
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
WHERE gatt IN('nup','up')
-- Use only rows which are older than 1 day:
AND 1+ydate < '&1'||' '||'&2'
/

-- rpt

SELECT gatt, COUNT(tkrdate) FROM bme GROUP BY gatt;

SELECT MAX(tkrdate) FROM bme;

-- Now build model from bme and score sme
@score1.sql
