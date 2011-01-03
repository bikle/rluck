--
-- de_dup_stkscores.sql
--

-- I use this script after I load stkscores from host-A into host-B.

DROP TABLE stktmp;
PURGE RECYCLEBIN;


CREATE TABLE stktmp COMPRESS AS
SELECT
tkrdate
,targ
,AVG(score)score
,MAX(rundate)rundate
,MAX(tkr)tkr
,MAX(ydate)ydate
FROM stkscores
GROUP BY tkrdate,targ
/

SELECT COUNT(*)FROM stkscores;
SELECT COUNT(*)FROM stktmp;

exit

DROP TABLE stkscores;
RENAME stktmp TO stkscores;

