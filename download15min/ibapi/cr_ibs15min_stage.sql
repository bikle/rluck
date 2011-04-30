--
-- cr_ibs15min_stage.sql
--

-- This table depends on this method:
-- historicalData()
-- in this file:
-- samples/base/SimpleWrapper.java

DROP TABLE ibs15min_stage;
CREATE TABLE ibs15min_stage(tkr VARCHAR2(8),epochsec NUMBER,clse NUMBER);
