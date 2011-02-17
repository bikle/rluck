--
-- qry_distinct_tkr.sql
--

-- I use this to give me a list of distinct tkrs.

SELECT './svmtkr.bash '||tkr FROM
(
SELECT DISTINCT tkr FROM ystk
UNION
SELECT DISTINCT tkr FROM di5min_stk_c2
UNION
SELECT DISTINCT tkr FROM ibs15min
)
ORDER BY tkr
/

exit
