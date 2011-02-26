--
-- qry_distinct_tkr.sql
--

-- I use this to give me a list of distinct tkrs.

SELECT './5min_data.bash '||tkr FROM
(
SELECT DISTINCT tkr FROM ystk
UNION
SELECT DISTINCT tkr FROM di5min_stk_c2
UNION
SELECT DISTINCT tkr FROM ibs15min
)
ORDER BY tkr
/

SELECT DISTINCT tkr FROM ystk
WHERE tkr NOT IN(SELECT DISTINCT tkr FROM di5min_stk_c2)
/

SELECT DISTINCT tkr FROM ystk
WHERE tkr NOT IN(SELECT DISTINCT tkr FROM ibs15min)
/

SELECT DISTINCT tkr FROM di5min_stk_c2
WHERE tkr NOT IN(SELECT DISTINCT tkr FROM ibs15min)
/

SELECT DISTINCT tkr FROM di5min_stk_c2
WHERE tkr NOT IN(SELECT DISTINCT tkr FROM ystk)
/

SELECT DISTINCT tkr FROM ibs15min
WHERE tkr NOT IN(SELECT DISTINCT tkr FROM di5min_stk_c2)
/

SELECT DISTINCT tkr FROM ibs15min
WHERE tkr NOT IN(SELECT DISTINCT tkr FROM ystk)
/

exit
