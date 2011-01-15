--
-- merge.sql
--

SELECT * FROM ystk_stage
WHERE ydate > sysdate -4
ORDER BY tkr,ydate
/

TRUNCATE TABLE ystk;

INSERT INTO ystk(tkr,ydate,tkrdate,clse,clse2,g1d)
SELECT
tkr
,ydate
,tkr||ydate
,clse
,LEAD(clse,1,NULL)OVER(PARTITION BY tkr ORDER BY ydate)clse2
,LEAD(clse,1,NULL)OVER(PARTITION BY tkr ORDER BY ydate)-clse g1d
FROM ystk_stage
ORDER BY tkr,ydate
/
