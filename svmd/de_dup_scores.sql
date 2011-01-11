--
-- de_dup_scores.sql
--

CREATE TABLE ys0 AS
SELECT
tkrdate
,AVG(score)score
,MAX(rundate)rundate
,tkr
,ydate
,targ
FROM ystkscores
GROUP BY tkrdate,tkr,ydate,targ
/

RENAME ystkscores TO ys2;

RENAME ys0 TO ystkscores;

DROP TABLE ys2;

exit

