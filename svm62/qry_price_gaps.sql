--
-- qry_price_gaps.sql
--

-- I use this script to help me see if ibf5min is missing any data.

SELECT
TRUNC(ydate)trunc_ydate
,TO_CHAR(TRUNC(ydate),'Dy')dday
,COUNT(ydate)
FROM ibf5min
WHERE ydate > sysdate - 33
GROUP BY TRUNC(ydate)
ORDER BY TRUNC(ydate)
/

exit
