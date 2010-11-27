--
-- score1hr.sql
--

-- I use this script to score 1 row constructed from svm6ms.
-- svm6ms is also the source of rows I use to build the model behind the SVM scoring algorithm.

-- Aside from the case_id and the target attribute, all columns in both sme and bme should be numeric.

-- Notice that I pass in ydate on the command line.
-- Demo: @score1hr.sql  2010-01-01 01:00:00

-- I start by building a view which holds the 1 row I want to score:
CREATE OR REPLACE VIEW sme AS
SELECT
'aud_usd'||ydate prdate
,NULL gatt
-- Numeric attributes for SVM.
-- Day-of-week:
,dow
-- Hour-of-day:
,hr
FROM svm6ms
WHERE ydate = '&1'||' '||'&2'
/

-- rpt
-- I should see only 1 row. This is the row I want to score:
SELECT COUNT(prdate)FROM sme;

-- Build a view which holds rows I use to fill the SVM model.
-- Notice that each row resides in sme's past.
-- I should not build a model which has access to data in sme's future.

CREATE OR REPLACE VIEW bme AS
SELECT
'aud_usd'||ydate prdate
,gatt
-- Numeric attributes for SVM.
-- Day-of-week:
,dow
-- Hour-of-day:
,hr
FROM svm6ms
-- I want data from the past, not present or future.
-- ydate6 is at least 6 hours ahead of ydate.
-- So, I block all rows where ydate6 is ahead of the 1 sme row.
WHERE ydate6 <= '&1'||' '||'&2'
AND gatt IN('nup','up')
/

-- rpt
SELECT ydate                 FROM svm6ms WHERE ydate  ='&1'||' '||'&2';
SELECT MAX(ydate),MAX(ydate6)FROM svm6ms WHERE ydate6<='&1'||' '||'&2';

SELECT gatt,MIN(prdate),COUNT(prdate),MAX(prdate)FROM bme GROUP BY gatt;

-- Now send both sme and bme to SVM.
-- It scores the 1 row in sme using rows in bme as a data source for the SVM model.
@svm_score.sql

INSERT INTO svm6scores (prdate,score,rundate)
SELECT
prdate
,PREDICTION_PROBABILITY(&model_name,'up' USING *)score
,sysdate
FROM svmc_apply_prep
/




