--
-- qry_spy_fri_noon.sql
--

-- I use this script to look at prices for SPY on Fridays.

SELECT
tkr
,TO_CHAR(ydate,'dy')dday
,0+TO_CHAR(ydate,'d')dnum
,AVG(g1)
,MIN(ydate)
,COUNT(g1)
,MAX(ydate)
FROM
(
  SELECT
  tkr
  ,ydate
  ,gain1day g1
  FROM di5min_stk_c2
  WHERE tkr = 'SPY'
)
WHERE tkr = 'SPY'
GROUP BY tkr,0+TO_CHAR(ydate,'d'),TO_CHAR(ydate,'dy')
ORDER BY tkr,0+TO_CHAR(ydate,'d'),TO_CHAR(ydate,'dy')
/

SELECT
tkr
,TO_CHAR(ydate,'dy hh24')hnum
,AVG(g1)
,MIN(ydate)
,COUNT(g1)
,MAX(ydate)
FROM
(
  SELECT
  tkr
  ,ydate
  ,gain1day g1
  FROM di5min_stk_c2
  WHERE tkr = 'SPY'
)
WHERE tkr = 'SPY'
AND TO_CHAR(ydate,'dy') = 'fri'
AND 0+TO_CHAR(ydate,'HH24')BETWEEN 15 AND 20
GROUP BY tkr,TO_CHAR(ydate,'dy hh24')
ORDER BY tkr,TO_CHAR(ydate,'dy hh24')
/

exit
