--
-- qry_tkrs_k_y.sql
--

SET PAGES 333

SELECT tkr FROM
  (SELECT DISTINCT tkr FROM ibs5min WHERE ydate > '2011-04-25'AND tkr>'K')
ORDER BY tkr
/

exit
