--
-- qry_distinct_tkr.sql
--

-- I use this to give me a list of distinct tkrs.

SET HEAD OFF PAGES 444

SELECT cmd FROM
  (SELECT DISTINCT './svmtkr.bash '||tkr cmd FROM ibs5min WHERE ydate > '2011-04-25')
ORDER BY cmd
/

exit

SELECT tkr FROM
(
SELECT DISTINCT tkr FROM ystk
UNION
SELECT DISTINCT tkr FROM di5min_stk_c2
UNION
SELECT DISTINCT tkr FROM ibs15min
)
ORDER BY tkr DESC
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
