--
-- merge.sql
--

TRUNCATE TABLE ystk;

INSERT INTO ystk(tkr,ydate,tkrdate,clse)
SELECT
tkr
,ydate
,tkr||ydate
,clse
FROM ystk_stage
/
