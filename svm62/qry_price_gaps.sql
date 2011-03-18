--
-- qry_price_gaps.sql
--

-- I use this script to help me see if ibf5min is missing any data.

ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD';

SELECT
trunc_ydate
,dday
,ccount
,CASE WHEN(dday='Sun'AND ccount!=126)THEN'bad_sunday'END bad_sunday
,CASE WHEN(dday='Fri'AND ccount!=1584)THEN'bad_friday'END bad_friday
,CASE WHEN(dday IN('mon','Tue','Wed','Thu')AND ccount<1710)THEN'bad_'||trunc_ydate END bad_weekday
FROM
(
SELECT
TRUNC(ydate)trunc_ydate
,TO_CHAR(TRUNC(ydate),'Dy')dday
,COUNT(ydate)ccount
FROM ibf5min
WHERE ydate > sysdate - 33
GROUP BY TRUNC(ydate)
)
ORDER BY trunc_ydate
/

exit
