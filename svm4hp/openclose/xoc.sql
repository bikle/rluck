--
-- xoc.sql
--

-- I use this script to help me execute open/close orders
SELECT
'./place_order.bash '||buysell shell_cmd
,30000 ssize
,REPLACE(UPPER(pair),'_',' ') pair
,TO_CHAR(opdate,'YYYYMMDD_hh24:mi:ss')||'_GMT' xopdate
,TO_CHAR(clsdate,'YYYYMMDD_hh24:mi:ss')||'_GMT'xclsdate
FROM oc
WHERE opdate > sysdate - 1/24
/

exit
