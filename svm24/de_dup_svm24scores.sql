--
-- de_dup_svm24scores.sql
--

-- I use this script after I load svm24scores from host-A into host-B.

SET LINES 66
DESC svm24tmp
DESC svm24scores
SET LINES 166

DROP TABLE svm24tmp;
PURGE RECYCLEBIN;


CREATE TABLE svm24tmp COMPRESS AS
SELECT
prdate
,targ
,AVG(score)score
,MAX(rundate)rundate
,MAX(pair)pair
,MAX(ydate)ydate
FROM svm24scores
GROUP BY prdate,targ
/

SELECT COUNT(*)FROM svm24scores;
SELECT COUNT(*)FROM svm24tmp;

DROP TABLE svm24scores;
RENAME svm24tmp TO svm24scores;

