--
-- de_dup_fx.sql
--

SET LINES 66
DESC fxscores4
SET LINES 166

DROP TABLE fxtmp;
PURGE RECYCLEBIN;


CREATE TABLE fxtmp COMPRESS AS
SELECT
prdate
,AVG(score)score
,MAX(rundate)rundate
,MAX(pair)pair
,MAX(ydate)ydate
FROM fxscores4
GROUP BY prdate
/

SELECT COUNT(*)FROM fxscores4;
SELECT COUNT(*)FROM fxtmp;

DROP TABLE fxscores4;
RENAME fxtmp TO fxscores4;

--

CREATE TABLE fxtmp COMPRESS AS
SELECT
prdate
,AVG(score)score
,MAX(rundate)rundate
,MAX(pair)pair
,MAX(ydate)ydate
FROM fxscores4_gattn
GROUP BY prdate
/

SELECT COUNT(*)FROM fxscores4_gattn;
SELECT COUNT(*)FROM fxtmp;

DROP TABLE fxscores4_gattn;
RENAME fxtmp TO fxscores4_gattn;
