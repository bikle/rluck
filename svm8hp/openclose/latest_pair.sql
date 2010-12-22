--
-- latest_pair.sql
--

SELECT 'llatest_pair'
,MAX(SUBSTR(prdate,1,3))pair
,MAX(TO_DATE(SUBSTR(prdate,4,22)))adate
FROM fxscores8hp_gattn
WHERE TO_DATE(SUBSTR(prdate,4,22)) =
  (SELECT MAX(TO_DATE(SUBSTR(prdate,4,22)))FROM fxscores8hp_gattn)
/
