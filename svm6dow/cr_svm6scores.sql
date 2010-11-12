--
-- cr_svm6scores.sql
--

-- I use this table to collect scores calculated by the SVM algorithm.
DROP   TABLE svm6scores;
CREATE TABLE svm6scores (prdate VARCHAR2(30),score NUMBER,rundate DATE);

exit
