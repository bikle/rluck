--
-- cr_di5min_stk.sql
--

-- The table, di5min_stk, contains data from duakas before '2010-12-27 09:00:00'
-- After that date, it holds data from IB.
-- See: update_di5min_stk.sql

CREATE TABLE di5min_stk0(tkrdate VARCHAR2(27),tkr VARCHAR2(7),ydate DATE,clse NUMBER);
CREATE TABLE di5min_stk (tkrdate VARCHAR2(27),tkr VARCHAR2(7),ydate DATE,clse NUMBER);
