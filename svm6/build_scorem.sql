--
-- build_scorem.sql
--

-- A simple SQL script I use to help me build another SQL script full of calls to the scoring script.
SET HEADING OFF

SELECT '@score1hr.sql ',ydate FROM svm6ms WHERE ydate > '2010-01-01'ORDER BY ydate;

exit
