--
-- corr_table.sql
--

-- I use this to show a simple 2D table of CORR() for each currency.

SET MARKUP HTML ON

SELECT pair, CORR(avg_npg1,avg_npg2)FROM hp4aggj GROUP BY pair ORDER BY pair;

exit
