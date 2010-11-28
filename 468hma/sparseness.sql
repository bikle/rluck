--
-- sparseness.sql
--

-- I use this query to help me see the sparseness of r2m when:
-- ma-slope is very steep
-- and data is recent

-- stddev4, npg4:
SELECT
ydate
,pair
,npg4
FROM v468hma
WHERE pair LIKE'%jpy'
AND sgn4 = -1
AND ABS(ma4_slope) > 2.1*stddev4
AND ydate > sysdate -66
ORDER BY ydate,pair
/

SELECT
pair
,SUM(npg4)
,AVG(npg4)
FROM v468hma
WHERE pair LIKE'%jpy'
AND sgn4 = -1
AND ABS(ma4_slope) > 2.1*stddev4
AND ydate > sysdate -66
GROUP BY pair
/


-- stddev6, npg4:

SELECT
ydate
,pair
,npg4
FROM v468hma
WHERE pair LIKE'%jpy'
AND sgn6 = -1
AND ABS(ma6_slope) > 2.1*stddev6
AND ydate > sysdate -66
ORDER BY ydate,pair
/

SELECT
pair
,SUM(npg4)
,AVG(npg4)
FROM v468hma
WHERE pair LIKE'%jpy'
AND sgn6 = -1
AND ABS(ma6_slope) > 2.1*stddev6
AND ydate > sysdate -66
GROUP BY pair
/


-- stddev8, npg4:

SELECT
ydate
,pair
,npg4
FROM v468hma
WHERE pair LIKE'%jpy'
AND sgn8 = -1
AND ABS(ma8_slope) > 2.1*stddev8
AND ydate > sysdate -66
ORDER BY ydate,pair
/

SELECT
pair
,SUM(npg4)
,AVG(npg4)
FROM v468hma
WHERE pair LIKE'%jpy'
AND sgn8 = -1
AND ABS(ma8_slope) > 2.1*stddev8
AND ydate > sysdate -66
GROUP BY pair
/

-- stddev6, npg6:

SELECT
ydate
,pair
,npg6
FROM v468hma
WHERE pair LIKE'%jpy'
AND sgn6 = -1
AND ABS(ma6_slope) > 2.1*stddev6
AND ydate > sysdate -66
ORDER BY ydate,pair
/

SELECT
pair
,SUM(npg6)
,AVG(npg6)
FROM v468hma
WHERE pair LIKE'%jpy'
AND sgn6 = -1
AND ABS(ma6_slope) > 2.1*stddev6
AND ydate > sysdate -66
GROUP BY pair
/

-- stddev8, npg6:

SELECT
ydate
,pair
,npg6
FROM v468hma
WHERE pair LIKE'%jpy'
AND sgn8 = -1
AND ABS(ma8_slope) > 2.1*stddev8
AND ydate > sysdate -66
ORDER BY ydate,pair
/

SELECT
pair
,SUM(npg6)
,AVG(npg6)
FROM v468hma
WHERE pair LIKE'%jpy'
AND sgn8 = -1
AND ABS(ma8_slope) > 2.1*stddev8
AND ydate > sysdate -66
GROUP BY pair
/

exit

