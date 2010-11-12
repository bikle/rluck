--
-- score1hr.sql
--

-- I use this script to score 1 row constructed from svm8ms.
-- svm8ms is also the source of rows I use to build the model behind the SVM scoring algorithm.

-- Aside from the case_id and the target attribute, all columns in both sme and bme should be numeric.

-- Notice that I pass in both pair and ydate on the command line.
-- Demo: @score1hr.sql  aud_usd 2010-01-01 01:00:00

-- I start buy building a view which holds the 1 row I want to score:
CREATE OR REPLACE VIEW sme AS
SELECT
'&1'||ydate prdate
,NULL gatt
-- Numeric attributes for SVM:
,ma6_slope
,ma8_slope
,ma9_slope
,ma12_slope
,ma18_slope
FROM svm8ms
WHERE ydate = '&2'||' '||'&3'
AND pair = '&1'
/

-- rpt
-- I should see only 1 row. This is the row I want to score:
SELECT COUNT(prdate)FROM sme;
SELECT * FROM sme;

-- Build a view which holds rows I use to fill the SVM model.
-- Notice that each row resides in sme's past.
-- I should not build a model which has access to data in sme's future.

CREATE OR REPLACE VIEW bme AS
SELECT
'&1'||ydate prdate
,gatt
-- Numeric attributes for SVM:
,ma6_slope
,ma8_slope
,ma9_slope
,ma12_slope
,ma18_slope
FROM svm8ms
-- I want data from the past, not present or future.
-- ydate8 is at least 8 hours ahead of ydate.
-- So, I block all rows where ydate8 is ahead of the 1 sme row.
WHERE ydate8 <= '&2'||' '||'&3'
AND gatt IN('nup','up')
AND pair = '&1'
/

-- rpt
SELECT pair,ydate FROM svm8ms            WHERE pair = '&1'AND ydate  ='&2'||' '||'&3'

SELECT MAX(ydate),MAX(ydate8)FROM svm8ms WHERE pair = '&1'AND ydate8<='&2'||' '||'&3'

SELECT
gatt,MIN(prdate),COUNT(prdate),MAX(prdate)
,AVG(ma6_slope)
,AVG(ma8_slope)
,AVG(ma9_slope)
,AVG(ma12_slope)
,AVG(ma18_slope)
FROM bme
GROUP BY gatt

exit

-- Now send both sme and bme to SVM.
-- It scores the 1 row in sme using rows in bme as a data source for the SVM model.
@svm_score.sql

INSERT INTO svm8scores (prdate,score,rundate)
SELECT
prdate
,PREDICTION_PROBABILITY(&model_name,'up' USING *)score
,sysdate
FROM svmc_apply_prep
/




