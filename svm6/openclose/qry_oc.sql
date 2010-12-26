--
-- qry_oc.sql
--

-- I use this script to see which positions I wanted to open in the past

SELECT
pair
,buysell
,score
,opdate
FROM oc
WHERE opdate > sysdate -1
ORDER BY opdate
/
