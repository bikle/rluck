--
-- qry_spy_sell_in_may.sql
--

CREATE OR REPLACE VIEW qsim10 AS
SELECT
ydate
,0+TO_CHAR(ydate,'MM')mmonth
,LEAD(clse,20,NULL)OVER(PARTITION BY tkr ORDER BY ydate) - clse g20
FROM ystk
WHERE tkr = 'SPY'
/

SELECT
MIN(ydate)
,COUNT(ydate)
,MAX(ydate)
FROM qsim10
/

SELECT
mmonth
,AVG(g20)avg_g20
FROM qsim10
GROUP BY mmonth
ORDER BY mmonth
/

exit
