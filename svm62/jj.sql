
SELECT
TO_CHAR(ydate,'WW')
,MIN(ydate)
,TO_CHAR(MIN(ydate),'Dy')minday
,COUNT(ydate)
,MAX(ydate)
,TO_CHAR(MAX(ydate),'Dy')maxday
FROM di5min
WHERE ydate > sysdate - (7 * 7)
GROUP BY 
TO_CHAR(ydate,'WW')
ORDER BY 
MIN(ydate)
/

exit

