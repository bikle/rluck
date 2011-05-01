--
-- merge.sql
--

-- I am interested in the real close, not the adj close.
-- In each CSV file, the real close comes right before volume.
-- In ystk_stage I call real-close: clse0
-- In ystk_stage I call adj-close: clse (which is confusing)
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
,clse0
,LEAD(clse0,1,NULL)OVER(PARTITION BY tkr ORDER BY ydate)clse2
,LEAD(clse0,1,NULL)OVER(PARTITION BY tkr ORDER BY ydate)-clse0 g1d
FROM ystk_stage
ORDER BY tkr,ydate
/
