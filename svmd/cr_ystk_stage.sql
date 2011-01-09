--
-- cr_ystk_stage.sql
--

-- clse is adj close

DROP TABLE ystk_stage;
CREATE TABLE ystk_stage(tkr VARCHAR2(11),ydate DATE,opn NUMBER,mx NUMBER,mn NUMBER,clse0 NUMBER,vol NUMBER,clse NUMBER);

