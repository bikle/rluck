--
-- score_j_model.sql
--

-- I use this script to join the score table with the model source so I can gauge the effectiveness of SVM.

-- See what I have to work with:
SELECT COUNT(npg),AVG(npg)FROM svm4ms;
SELECT COUNT(score),AVG(score)FROM svm4scores;

CREATE OR REPLACE VIEW score_j_model AS
SELECT pair,ydate,m.prdate,score,npg FROM svm4scores s, svm4ms m
WHERE s.prdate = m.prdate
/

SELECT pair,COUNT(score),CORR(score,npg),AVG(npg),SUM(npg)FROM score_j_model GROUP BY pair;

SELECT pair,COUNT(score),CORR(score,npg),AVG(npg),SUM(npg),MIN(npg),STDDEV(npg),MAX(npg)
FROM score_j_model
WHERE score > 0.5 GROUP BY pair
/

SELECT pair,COUNT(score),CORR(score,npg),AVG(npg),SUM(npg),MIN(npg),STDDEV(npg),MAX(npg)
FROM score_j_model
WHERE score > 0.75 GROUP BY pair
/

exit
