--
-- score_j_model.sql
--

-- I use this script to join the score table with the model source so I can gauge the effectiveness of SVM.

-- See what I have to work with:
SELECT COUNT(npg),AVG(npg)FROM svm6ms;
SELECT COUNT(score),AVG(score)FROM svm6scores;

CREATE OR REPLACE VIEW score_j_model AS
SELECT score,npg FROM svm6scores s, svm6ms m
WHERE s.prdate = 'aud_usd'||ydate
/

SELECT COUNT(score),CORR(score,npg),AVG(npg),SUM(npg)FROM score_j_model;
SELECT COUNT(score),CORR(score,npg),AVG(npg),SUM(npg)FROM score_j_model WHERE score > 0.5;

exit
