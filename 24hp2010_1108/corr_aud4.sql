--
-- corr_aud4.sql
--

-- Use CORR() to help me answer a simple question:
-- If the aud_usd, 4_02 combo conformed to the correlation trend,
-- did aud_usd, 4_13 also conform?

-- Look for visual correlation of 4_02 results with 4_13 results.
SELECT ydatea, npga,npgb FROM
  (SELECT ydate ydatea, npg npga FROM hdp WHERE pair = 'aud_usd'AND dhr = '4_02')
 ,(SELECT ydate ydateb, npg npgb FROM hdp WHERE pair = 'aud_usd'AND dhr = '4_13')
WHERE ydatea + 11/24 = ydateb
ORDER BY ydatea
/

-- Now, calculate CORR():

SELECT COUNT(*),CORR(npga,npgb)FROM
-- SELECT ydatea, npga,npgb FROM
  (SELECT ydate ydatea, npg npga FROM hdp WHERE pair = 'aud_usd'AND dhr = '4_02')
 ,(SELECT ydate ydateb, npg npgb FROM hdp WHERE pair = 'aud_usd'AND dhr = '4_13')
WHERE ydatea + 11/24 = ydateb
ORDER BY ydatea
/

exit

