--
-- qry_tkrs_j_y.sql
--

SET PAGES 333

SELECT tkr FROM
  (SELECT DISTINCT tkr FROM ibs5min WHERE ydate > '2011-04-25'AND tkr>'J')
ORDER BY tkr
/

exit