--
-- cr_ibf_stage.sql
--

-- This table depends on this method:
-- historicalData()
-- in this file:
-- samples/base/SimpleWrapper.java
-- DROP TABLE ibf_stage;
CREATE TABLE ibf_stage(pair VARCHAR2(8),epochsec NUMBER,clse NUMBER);
