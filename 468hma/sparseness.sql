--
-- sparseness.sql
--

-- I use this query to help me see the frequency of r2m when ma-slope is very steep.

SELECT
ydate
,pair
,npg4
FROM v468hma14
WHERE pair IN('aud_usd','eur_gbp')
AND sgn4 = -1
AND ABS(ma4_slope) > 2.1*stddev4
AND ydate > sysdate -66
ORDER BY ydate,pair
/

SELECT
pair
,SUM(npg4)
,AVG(npg4)
FROM v468hma14
WHERE pair IN('aud_usd','eur_gbp')
AND sgn4 = -1
AND ABS(ma4_slope) > 2.1*stddev4
AND ydate > sysdate -66
GROUP BY pair
/

SELECT
ydate
,AVG(npg4)
,SUM(npg4)
,COUNT(npg4)
FROM v468hma14
WHERE pair IN
('eur_aud','eur_chf','gbp_aud','gbp_cad','gbp_chf','gbp_jpy','gbp_usd','usd_cad','usd_chf','usd_jpy')
AND sgn4 = 1
AND ABS(ma4_slope) > 2.1*stddev4
AND ydate > sysdate -66
GROUP BY ydate
ORDER BY ydate
/

SELECT
pair
,SUM(npg4)
,AVG(npg4)
FROM v468hma14
WHERE pair IN
('eur_aud','eur_chf','gbp_aud','gbp_cad','gbp_chf','gbp_jpy','gbp_usd','usd_cad','usd_chf','usd_jpy')
AND sgn4 = 1
AND ABS(ma4_slope) > 2.1*stddev4
AND ydate > sysdate -66
GROUP BY pair
ORDER BY pair
/

SELECT
SUM(npg4)
,AVG(npg4)
FROM v468hma14
WHERE pair IN
('eur_aud','eur_chf','gbp_aud','gbp_cad','gbp_chf','gbp_jpy','gbp_usd','usd_cad','usd_chf','usd_jpy')
AND sgn4 = 1
AND ABS(ma4_slope) > 2.1*stddev4
AND ydate > sysdate -66
/

exit
