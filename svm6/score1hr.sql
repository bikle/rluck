--
-- score1hr.sql
--

-- I use this script to score 1 row constructed from svm6ms.
-- svm6ms is also the source of rows I use to build the model behind the SVM scoring algorithm.

-- Aside from the case_id and the target attribute, all columns in both sme and bme should be numeric.

CREATE OR REPLACE VIEW sme AS
SELECT
'aud_usd'||ydate prdate
,NULL gatt
-- Numeric attributes for SVM:
,dow
,hr
FROM svm6ms
WHERE ydate = '&1'||' '||'&2'
/

-- rpt
-- I should see only 1 row. This is the row I want to score:
SELECT COUNT(*)FROM sme;
DESC sme

exit

