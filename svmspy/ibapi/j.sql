
-- rpt
SELECT
TO_CHAR(ydate,'Day')
,COUNT(tkr)
FROM dukas5min_stk
WHERE ydate < '2010-12-27 09:00:00'
GROUP BY TO_CHAR(ydate,'Day')
ORDER BY TO_CHAR(ydate,'Day')
/
