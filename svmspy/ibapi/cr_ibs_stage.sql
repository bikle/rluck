--
-- cr_ibs_stage.sql
--

-- This table depends on this method:
-- historicalData()
-- in this file:
-- samples/base/SimpleWrapper.java

DROP TABLE ibs_stage;
CREATE TABLE ibs_stage(tkr VARCHAR2(8),epochsec NUMBER,clse NUMBER);
