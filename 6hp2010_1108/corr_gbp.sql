--
-- corr_gbp.sql
--

-- Use CORR() to help me answer a simple question:
-- If the gbp_usd, 3_10 combo conformed to the correlation trend,
-- did gbp_usd, 3_14 also conform?

-- Look for visual correlation of 3_10 results with 3_14 results.
SELECT ydatea, npga,npgb FROM
  (SELECT ydate ydatea, npg npga FROM hp12 WHERE pair = 'gbp_usd'AND dhr = '3_10')
 ,(SELECT ydate ydateb, npg npgb FROM hp12 WHERE pair = 'gbp_usd'AND dhr = '3_14')
WHERE TRUNC(ydatea) = TRUNC(ydateb)
ORDER BY ydatea
/

-- Now, calculate CORR():

SELECT COUNT(*),CORR(npga,npgb)FROM
-- SELECT ydatea, npga,npgb FROM
  (SELECT ydate ydatea, npg npga FROM hp12 WHERE pair = 'gbp_usd'AND dhr = '3_10')
 ,(SELECT ydate ydateb, npg npgb FROM hp12 WHERE pair = 'gbp_usd'AND dhr = '3_14')
WHERE TRUNC(ydatea) = TRUNC(ydateb)
ORDER BY ydatea
/

exit

