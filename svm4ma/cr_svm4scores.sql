--
-- cr_svm4scores.sql
--

-- I use this table to collect scores calculated by the SVM algorithm.
DROP   TABLE svm4scores;
CREATE TABLE svm4scores (prdate VARCHAR2(30),score NUMBER,rundate DATE);

exit
