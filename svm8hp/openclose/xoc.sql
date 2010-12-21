--
-- xoc.sql
--

-- I use this script to help me execute open/close orders.

SELECT
'./place_order.bash '||buysell shell_cmd
,30000 ssize
,REPLACE(UPPER(pair),'_',' ') pair
-- Set opdate to recent-past to avoid clock skew.
-- IB equates recent-past to right-now:
,TO_CHAR(opdate-1/24,'YYYYMMDD_hh24:mi:ss')||'_GMT' xopdate
,TO_CHAR(clsdate,'YYYYMMDD_hh24:mi:ss')||'_GMT'xclsdate
FROM oc
WHERE opdate > sysdate - 30/60/24
-- Try to avoid entering duplicate orders:
AND prdate NOT IN(SELECT prdate FROM xoc)
/

-- Try to avoid entering duplicate orders:
INSERT INTO xoc(prdate,xocdate)
SELECT prdate,sysdate FROM oc
WHERE opdate > sysdate - 30/60/24
/

-- How many orders have I entered?:
SELECT COUNT(*)FROM xoc;

-- recently?:
SELECT * FROM xoc WHERE xocdate > sysdate - 1 ORDER BY xocdate;

exit
