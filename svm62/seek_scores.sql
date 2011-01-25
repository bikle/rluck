--
-- seek_scores.sql
--

-- I use this script to seek times when scores are high.

SELECT TO_CHAR(sysdate,'D_HH24') dhr FROM dual;

SELECT
targ
,pair
,TO_CHAR(ydate,'D_HH24') dhr
,COUNT(TO_CHAR(ydate,'D_HH24'))ccount
,AVG(score)avg_score
FROM svm62scores
WHERE TO_CHAR(ydate,'d')IN(2,3)
AND pair IN('aud_usd','eur_usd','usd_cad','usd_chf','usd_jpy','aud_jpy','eur_jpy')
-- AND pair NOT IN('gbp_usd','eur_aud','eur_chf','eur_gbp')
GROUP BY targ,pair,TO_CHAR(ydate,'D_HH24')
HAVING(AVG(score) > 0.7 OR AVG(score) < 0.3)
ORDER BY TO_CHAR(ydate,'D_HH24'),targ,pair
/

exit
