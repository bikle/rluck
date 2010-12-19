--
-- cr_fxscores.sql
--

-- I use fxscores to collect scores from SVM.

-- DROP TABLE fxscores;
-- DROP TABLE fxscores_gattn;

CREATE TABLE fxscores      (prdate VARCHAR2(34),score NUMBER,rundate DATE,pair VARCHAR2(8),ydate DATE,score2 NUMBER);

CREATE TABLE fxscores_gattn(prdate VARCHAR2(34),score NUMBER,rundate DATE,pair VARCHAR2(8),ydate DATE,score2 NUMBER);
