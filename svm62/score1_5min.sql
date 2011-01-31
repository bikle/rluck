--
-- score1_5min.sql
--

-- Demo:
-- @score1_5min.sql 2010-12-31 20:45:01 aud_usd

CREATE OR REPLACE VIEW sme AS
SELECT
prdate
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
,g30
,g31
,g32
,g33
,g34
,g35
,g36
,g37
,g38
,g39
,g40
,g41
,s.sc_corr
FROM modsrc
,(SELECT AVG(sc_corr)sc_corr FROM modsrc WHERE 2+ydate>'&1'||' '||'&2'AND ydate<'&1'||' '||'&2')s
WHERE ydate = '&1'||' '||'&2'
AND pair = '&3'
/

-- rpt
-- We should see just 1 row:

SELECT COUNT(prdate) FROM sme

-- Build the model:
CREATE OR REPLACE VIEW bme AS
SELECT
prdate
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
,g30
,g31
,g32
,g33
,g34
,g35
,g36
,g37
,g38
,g39
,g40
,g41
,sc_corr
FROM modsrc
WHERE gatt IN('nup','up')
-- Use only rows which are older than 1 day:
AND 1+ydate < '&1'||' '||'&2'
AND pair = '&3'
/

-- rpt

SELECT gatt, COUNT(prdate) FROM bme GROUP BY gatt

SELECT MAX(prdate) FROM bme

-- Now build model from bme and score sme
@score1.sql gatt
