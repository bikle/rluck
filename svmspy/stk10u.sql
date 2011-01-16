--
-- stk10u.sql
--

-- I use this script to mix data from stk_ms_svmspy and stk_ms

-- I need to run stk10.sql before I run stk10svmd.sql
@stk10.sql     '&1'
@stk10svmd.sql '&1'


DROP TABLE   stk_ms_u;

PURGE RECYCLEBIN;

CREATE TABLE stk_ms_u COMPRESS AS
SELECT * FROM stk_ms_svmspy
UNION
SELECT * FROM stk_ms_svmd_svmspy
/

exit
