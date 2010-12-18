-- score1gattn.sql

-- Does the 1st SVM score

-- Fill up svmc_apply_prep
@score_gattn.sql

-- Use same model_name used in score_gattn.sql
DEFINE model_name = 'forex14'

DELETE fxscores8hp_gattn WHERE score > 0 AND prdate IN(SELECT prdate FROM svmc_apply_prep);

INSERT INTO fxscores8hp_gattn (prdate,score,rundate,pair,ydate)
SELECT
prdate
,PREDICTION_PROBABILITY(&model_name,'up' USING *)score
,sysdate
,SUBSTR(prdate,1,3)pair
,SUBSTR(prdate,4,19)ydate
FROM svmc_apply_prep
/
