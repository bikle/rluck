--
-- cr_stkscores.sql
--

-- I use this script to create tables to hold SVM scores after SVM calculates them.

DROP TABLE stkscores;

CREATE TABLE stkscores(tkrdate VARCHAR2(30),score NUMBER,rundate DATE,tkr VARCHAR2(8),ydate DATE,targ VARCHAR2(5));

exit
