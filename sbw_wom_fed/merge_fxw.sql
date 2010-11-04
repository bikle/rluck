--
-- merge_fxw.sql
--

-- I use this to merge newly loaded data from fxw_stage into fxw which may eventually hold more permanent data.
-- Currently, though, I just do a straight copy (filtering out duplicates) from fxw_stage into fxw.
DROP TABLE fxw_old;

RENAME fxw TO fxw_old;

CREATE TABLE fxw COMPRESS AS 
SELECT
pair,ydate,AVG(clse)clse
FROM fxw_stage
GROUP BY pair,ydate
ORDER BY pair,ydate
/

ANALYZE TABLE fxw COMPUTE STATISTICS;

-- rpt
SELECT COUNT(pair)FROM fxw_stage;
SELECT COUNT(pair)FROM fxw;


SELECT COUNT(DISTINCT pair||ydate)FROM fxw_stage;
SELECT COUNT(DISTINCT pair||ydate)FROM fxw;

exit

