--
-- cr_stkscores.sql
--

-- I use this script to create tables to hold SVM scores after SVM calculates them.

DROP TABLE stkscores;
DROP TABLE stkscores_gattn;

CREATE TABLE stkscores(tkrdate VARCHAR2(30),score NUMBER,rundate DATE,tkr VARCHAR2(8),ydate DATE);

CREATE TABLE stkscores_gattn(tkrdate VARCHAR2(30),score NUMBER,rundate DATE,tkr VARCHAR2(8),ydate DATE);

exit
