--
-- cr_ystk.sql
--

DROP TABLE ystk;

CREATE TABLE ystk
(
tkr      VARCHAR2(9)
,ydate   DATE
,tkrdate VARCHAR2(24)
,clse    NUMBER
-- Close 1 day in future:
,clse2   NUMBER
-- Gain of 1 day:
,g1d     NUMBER
)
/
