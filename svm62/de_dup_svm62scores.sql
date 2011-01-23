--
-- de_dup_svm62scores.sql
--

-- I use this script after I load svm62scores from host-A into host-B.

SET LINES 66
DESC svm62tmp
DESC svm62scores
SET LINES 166

DROP TABLE svm62tmp;
PURGE RECYCLEBIN;


CREATE TABLE svm62tmp COMPRESS AS
SELECT
prdate
,targ
,AVG(score)score
,MAX(rundate)rundate
,MAX(pair)pair
,MAX(ydate)ydate
FROM svm62scores
GROUP BY prdate,targ
/

SELECT COUNT(*)FROM svm62scores;
SELECT COUNT(*)FROM svm62tmp;

DROP TABLE svm62scores;
RENAME svm62tmp TO svm62scores;

