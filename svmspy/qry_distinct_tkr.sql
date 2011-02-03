--
-- qry_distinct_tkr.sql
--

-- I use this to give me a list of distinct tkrs.

SELECT tkr FROM
(
SELECT DISTINCT tkr FROM ystk
UNION
SELECT DISTINCT tkr FROM di5min_stk_c2
)
ORDER BY tkr
/

exit
