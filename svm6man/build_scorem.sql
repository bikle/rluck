--
-- build_scorem.sql
--

-- A simple SQL script I use to help me build another SQL script full of calls to the scoring script.
SET HEADING OFF

-- I only want to score rows from 2010:
SELECT '@score1hr.sql ',pair,ydate FROM svm6ms WHERE ydate > '2010-01-01'
AND prdate NOT IN(SELECT prdate FROM svm6scores)
ORDER BY pair,ydate;

exit
