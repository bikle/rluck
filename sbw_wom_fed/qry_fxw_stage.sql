--
-- qry_fxw_stage.sql
--

-- This helps me see recently loaded data.

SELECT pair,MIN(ydate),COUNT(ydate),MAX(ydate)FROM fxw_stage GROUP BY pair ORDER BY pair ;

SELECT pair,ydate,clse FROM fxw_stage WHERE ydate IN(SELECT MAX(ydate)FROM fxw_stage);

EXIT
