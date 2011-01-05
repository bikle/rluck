--
-- de_dup_stkscores_1hr.sql
--

-- I use this script after I load stkscores_1hr from host-A into host-B.

SET LINES 66
DESC stktmp
DESC stkscores_1hr
SET LINES 166

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
FROM stkscores_1hr
GROUP BY tkrdate,targ
/

SELECT COUNT(*)FROM stkscores_1hr;
SELECT COUNT(*)FROM stktmp;

DROP TABLE stkscores_1hr;
RENAME stktmp TO stkscores_1hr;

