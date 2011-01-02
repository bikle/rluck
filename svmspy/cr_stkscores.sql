--
-- cr_stkscores.sql
--

-- I use this script to create tables to hold SVM scores after SVM calculates them.

CREATE TABLE stkscores(tkrdate VARCHAR2(30),score NUMBER,rundate DATE,pair VARCHAR2(8),ydate DATE);

CREATE TABLE stkscores_gattn(tkrdate VARCHAR2(30),score NUMBER,rundate DATE,pair VARCHAR2(8),ydate DATE);

exit
