--
-- gendl.sql
--

-- I use this script to help me build a set of shell commands from tkrs with high score-corr-values.

-- I depend on score_corr.sql so I run that 1st:
@score_corr

SELECT
'./dl_then_svm.bash'
,tkr
,score_corr
FROM score_corr_svmspy
WHERE ccount > 9
AND max_date > sysdate - 3
AND score_corr > 0.0
ORDER BY score_corr DESC
/


