-- score1gattn.sql

-- Does the 1st SVM score

-- Fill up svmc_apply_prep
@score_gattn.sql

-- Use same model_name used in score.sql
DEFINE model_name = 'svmspy100'

-- Maybe I already collected a score for this tkrdate.
-- DELETE it if I did:
DELETE stkscores_gattn WHERE score > 0 AND tkrdate IN(SELECT tkrdate FROM svmc_apply_prep);

INSERT INTO stkscores_gattn (tkrdate,score,rundate,pair,ydate)
SELECT
tkrdate
,PREDICTION_PROBABILITY(&model_name,'up' USING *)score
,sysdate
,SUBSTR(tkrdate,1,3)pair
,SUBSTR(tkrdate,4,19)ydate
FROM svmc_apply_prep
/
