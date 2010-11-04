
SELECT
prdate
,PREDICTION_PROBABILITY(&model_name,'up' USING *)prob_up
,sysdate
,REPLACE(tkrdate,SUBSTR(tkrdate,-19,19),'')tkr
,SUBSTR(tkrdate,-19,19)ydate
FROM svmc_apply_prep
/
