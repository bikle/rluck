--
-- de_dup_fx.sql
--

SET LINES 66
DESC fxscores8hp
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
FROM fxscores8hp
GROUP BY prdate
/

SELECT COUNT(*)FROM fxscores8hp;
SELECT COUNT(*)FROM fxtmp;

DROP TABLE fxscores8hp;
RENAME fxtmp TO fxscores8hp;

--

CREATE TABLE fxtmp COMPRESS AS
SELECT
prdate
,AVG(score)score
,MAX(rundate)rundate
,MAX(pair)pair
,MAX(ydate)ydate
FROM fxscores8hp_gattn
GROUP BY prdate
/

SELECT COUNT(*)FROM fxscores8hp_gattn;
SELECT COUNT(*)FROM fxtmp;

DROP TABLE fxscores8hp_gattn;
RENAME fxtmp TO fxscores8hp_gattn;
