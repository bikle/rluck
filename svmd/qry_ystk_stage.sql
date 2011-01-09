--
-- qry_ystk_stage.sql
--

SET LINES 66
DESC ystk_stage
SET LINES 166

SELECT * FROM ystk_stage
WHERE ydate > sysdate -11
ORDER BY ydate
/


