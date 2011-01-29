--
-- score1_5min.sql
--

-- Demo:
-- @score1_5min.sql 2010-12-31 SPY

CREATE OR REPLACE VIEW sme AS
SELECT
tkrdate
,NULL gatt
-- ,NVL(s.sc_corr,0)sc_corr
,g00
,g01
,g02
,g03
,g04
,g05
,g06
,g07
,g08
,g09
,g10
,g11
,g12
,g13
,g14
,g15
,g16
,g17
,g18
,g19
,g20
,g21
,g22
,g23
,g24
,g25
,g26
,g27
,g28
,g29
FROM stk_ms
-- ,(SELECT AVG(sc_corr)sc_corr FROM stk_ms WHERE 11+ydate>'&1'AND 2+ydate<'&1')s
WHERE ydate = '&1'
AND tkr = '&2'
/

-- rpt
-- We should see just 1 row:

SELECT COUNT(tkrdate) FROM sme;

-- SELECT AVG(sc_corr)sc_corr FROM stk_ms WHERE 11+ydate>'&1'AND 2+ydate<'&1' ;

-- Build the model:
CREATE OR REPLACE VIEW bme AS
SELECT
tkrdate
,gatt
-- ,NVL(sc_corr,0)sc_corr
,g00
,g01
,g02
,g03
,g04
,g05
,g06
,g07
,g08
,g09
,g10
,g11
,g12
,g13
,g14
,g15
,g16
,g17
,g18
,g19
,g20
,g21
,g22
,g23
,g24
,g25
,g26
,g27
,g28
,g29
FROM stk_ms
WHERE gatt IN('nup','up')
-- Use only rows which are older than 1 day:
AND 1+ydate < '&1'
AND tkr = '&2'
/

-- rpt

-- SELECT gatt, AVG(sc_corr), COUNT(tkrdate) FROM bme GROUP BY gatt;

SELECT MAX(tkrdate) FROM bme

-- Now build model from bme and score sme
@score1.sql gatt
