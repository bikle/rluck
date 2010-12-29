-- score1gattn.sql

-- Does the 1st SVM score

-- Fill up svmc_apply_prep
@score_gattn.sql

-- Use same model_name used in score.sql
DEFINE model_name = 'forex14'

-- Maybe I already collected a score for this prdate.
-- DELETE it if I did:
DELETE fxscores_demo_gattn WHERE score > 0 AND prdate IN(SELECT prdate FROM svmc_apply_prep);

INSERT INTO fxscores_demo_gattn (prdate,score,rundate,pair,ydate)
SELECT
prdate
,PREDICTION_PROBABILITY(&model_name,'up' USING *)score
,sysdate
,SUBSTR(prdate,1,3)pair
,SUBSTR(prdate,4,19)ydate
FROM svmc_apply_prep
/
