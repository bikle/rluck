--
-- build_scorem.sql
--

-- A simple SQL script I use to help me build another SQL script full of calls to the scoring script.
SET HEADING OFF

-- I only want to score rows after 2010-04-01:
SELECT '@score1hr.sql ',pair,ydate
FROM svm4ms
WHERE ydate > '2010-04-01'
AND prdate NOT IN(SELECT prdate FROM svm4scores)
ORDER BY pair,ydate
/

exit
