--
-- qry_wjw11woq.sql
--

SET LINES 66
DESC wjw
SET LINES 166

SELECT
qtr
,-AVG(wgain)
FROM wjw
WHERE pair = 'usd_chf'
AND yr = '2010'
AND woq = 11
GROUP BY qtr
ORDER BY qtr
/

SELECT
qtr
,-AVG(wgain)
FROM wjw
WHERE pair = 'usd_chf'
AND yr = '2009'
AND woq = 11
GROUP BY qtr
ORDER BY qtr
/

SELECT
qtr
,-AVG(wgain)
FROM wjw
WHERE pair = 'usd_chf'
AND yr = '2008'
AND woq = 11
GROUP BY qtr
ORDER BY qtr
/

SELECT
qtr
,-AVG(wgain)
FROM wjw
WHERE pair = 'usd_chf'
AND yr = '2007'
AND woq = 11
GROUP BY qtr
ORDER BY qtr
/

exit
