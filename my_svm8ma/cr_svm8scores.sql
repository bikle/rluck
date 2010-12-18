--
-- cr_svm8scores.sql
--

-- I use this table to collect scores calculated by the SVM algorithm.
DROP   TABLE svm8scores;
CREATE TABLE svm8scores (prdate VARCHAR2(30),score NUMBER,rundate DATE);

exit
