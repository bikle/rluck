--
-- de_dup_fx.sql
--

SET LINES 66
DESC fxscores6
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
FROM fxscores6
GROUP BY prdate
/

SELECT COUNT(*)FROM fxscores6;
SELECT COUNT(*)FROM fxtmp;

DROP TABLE fxscores6;
RENAME fxtmp TO fxscores6;

--

CREATE TABLE fxtmp COMPRESS AS
SELECT
prdate
,AVG(score)score
,MAX(rundate)rundate
,MAX(pair)pair
,MAX(ydate)ydate
FROM fxscores6_gattn
GROUP BY prdate
/

SELECT COUNT(*)FROM fxscores6_gattn;
SELECT COUNT(*)FROM fxtmp;

DROP TABLE fxscores6_gattn;
RENAME fxtmp TO fxscores6_gattn;
