-- score1.sql

-- Does the 1st SVM score

-- Fill up svmc_apply_prep
@score.sql

-- Use same model_name used in score.sql
DEFINE model_name = 'forex14'

-- CREATE TABLE fxscores (prdate VARCHAR2(34),score NUMBER,rundate DATE,pair VARCHAR2(8),ydate DATE, score2 NUMBER);

DELETE fxscores WHERE score > 0 AND prdate IN(SELECT prdate FROM svmc_apply_prep);

INSERT INTO fxscores (prdate,score,rundate,pair,ydate)
SELECT
prdate
,PREDICTION_PROBABILITY(&model_name,'up' USING *)score
,sysdate
,SUBSTR(prdate,1,3)pair
,SUBSTR(prdate,4,19)ydate
FROM svmc_apply_prep
/
