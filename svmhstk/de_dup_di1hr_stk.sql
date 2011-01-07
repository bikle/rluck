--
-- de_dup_di1hr_stk.sql
--

SET LINES 66
DESC di1hr_stk
SET LINES 166

CREATE TABLE di1hr_stk_dd COMPRESS AS
SELECT
tkrdate
,tkr
,ydate
,AVG(clse)clse
FROM di1hr_stk
GROUP BY 
tkrdate
,tkr
,ydate
ORDER BY 
tkrdate
,tkr
,ydate
/

DROP TABLE di1hr_stk;

RENAME di1hr_stk_dd TO di1hr_stk;
