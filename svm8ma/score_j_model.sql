--
-- score_j_model.sql
--

-- I use this script to join the score table with the model source so I can gauge the effectiveness of SVM.

-- See what I have to work with:
SELECT COUNT(npg),AVG(npg)FROM svm8ms;
SELECT COUNT(score),AVG(score)FROM svm8scores;

CREATE OR REPLACE VIEW score_j_model AS
SELECT pair,ydate,m.prdate,score,npg FROM svm8scores s, svm8ms m
WHERE s.prdate = m.prdate
/

SELECT COUNT(score),CORR(score,npg),AVG(npg),SUM(npg)FROM score_j_model;
SELECT COUNT(score),CORR(score,npg),AVG(npg),SUM(npg)FROM score_j_model WHERE score > 0.5;

exit
