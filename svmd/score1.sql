-- score1.sql

-- I use this script to send 5 params to score.sql
-- which does the heavy lifting of creating an SVM model.
-- Then at the very end of this script I use the model
-- inside an INSERT via a call to: PREDICTION_PROBABILITY()

-- I call this script from 2 other scripts:
-- score1_5min.sql
-- score1_5min_gattn.sql

-- The 1st param is the name of the target attribute.
-- I like to call my target attributes either gatt or gattn.

-- Demo:
-- @score1.sql 'gatt'
-- @score1.sql 'gattn'

-- Now, I fill up svmc_apply_prep.
-- I use same model_name used in score.sql
DEFINE model_name = 'svmspy101'
DEFINE bldtable   = 'bme'
DEFINE scoretable = 'sme'
DEFINE case_id    = 'tkrdate'
-- Demo:
-- @score.sql gatt svmspy100   bme         sme           tkrdate
@score.sql '&1' '&model_name' '&bldtable' '&scoretable' '&case_id'

-- Maybe I already collected a score for this tkrdate.
-- DELETE it if I did:
DELETE ystkscores
WHERE score > 0
AND tkrdate IN(SELECT tkrdate FROM svmc_apply_prep)
-- I need to supply the target attribute name:
AND targ = '&1'
/

-- We do a drumroll here:

INSERT INTO ystkscores (tkrdate,score,rundate,tkr,ydate,targ)
SELECT
tkrdate
,PREDICTION_PROBABILITY(&model_name,'up' USING *)score
,sysdate
-- ,SUBSTR(tkrdate,1,3)tkr
-- rluck/oracle_sql_demos/substr.sql :
,SUBSTR(tkrdate,-LENGTH(tkrdate),LENGTH(tkrdate)-10)tkr
,SUBSTR(tkrdate,-10)ydate
,'&1'
FROM svmc_apply_prep
/
