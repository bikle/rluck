
select max(tkrdate)from svmc_apply_prep;

select SUBSTR(max(tkrdate),1,4)from svmc_apply_prep;

select SUBSTR(max(tkrdate),-19,4)from svmc_apply_prep;

-- rluck/oracle_sql_demos/substr.sql

select SUBSTR(max(tkrdate),-LENGTH(max(tkrdate)),LENGTH(max(tkrdate))-19)from svmc_apply_prep;


SELECT
tkrdate
,PREDICTION_PROBABILITY(&model_name,'up' USING *)score
,sysdate rundate
-- ,SUBSTR(tkrdate,1,3)tkr
-- rluck/oracle_sql_demos/substr.sql :
,SUBSTR(tkrdate,-LENGTH(tkrdate),LENGTH(tkrdate)-19)tkr
,SUBSTR(tkrdate,-19)ydate
FROM svmc_apply_prep
/

