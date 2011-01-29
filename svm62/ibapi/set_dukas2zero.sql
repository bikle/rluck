--
-- set_dukas2zero.sql
--

-- I use this script to zero-out some dates which are 1 second past the minute.

-- Look for the data 1st:
SELECT COUNT(ydate),0+TO_CHAR(ydate,'SS')
FROM dukas5min
GROUP BY 0+TO_CHAR(ydate,'SS')
/

SELECT COUNT(ydate),0+TO_CHAR(
TO_DATE(TO_CHAR(ydate,'YYYY-MM-DD HH24:MI'))
,'SS')
FROM dukas5min
GROUP BY TO_CHAR(
TO_DATE(TO_CHAR(ydate,'YYYY-MM-DD HH24:MI'))
,'SS')
/

UPDATE dukas5min
SET ydate = TO_DATE(TO_CHAR(ydate,'YYYY-MM-DD HH24:MI'))
/

-- Look for the data again:

SELECT COUNT(ydate),0+TO_CHAR(ydate,'SS')
FROM dukas5min
GROUP BY 0+TO_CHAR(ydate,'SS')
/

exit

