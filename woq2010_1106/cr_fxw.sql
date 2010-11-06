--
-- /pt/s/rlk/sbw_woq/cr_fxw.sql
--

DROP TABLE fxw_stage;
CREATE TABLE fxw_stage(ydate DATE, clse NUMBER, pair VARCHAR2(7));

DROP TABLE fxw;
CREATE TABLE fxw      (ydate DATE, clse NUMBER, pair VARCHAR2(7));

exit

