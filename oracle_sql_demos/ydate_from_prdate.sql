
SELECT
prdate
,PREDICTION_PROBABILITY(&model_name,'up' USING *)prob_up
,sysdate
,SUBSTR(prdate,1,7)pair
,SUBSTR(prdate,8,19)ydate
FROM svmc_apply_prep
/
