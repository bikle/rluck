--
-- merge.sql
--

SELECT * FROM ystk_stage
WHERE ydate > sysdate -4
ORDER BY tkr,ydate
/

TRUNCATE TABLE ystk;

INSERT INTO ystk(tkr,ydate,tkrdate,clse)
SELECT
tkr
,ydate
,tkr||ydate
,clse
FROM ystk_stage
/
