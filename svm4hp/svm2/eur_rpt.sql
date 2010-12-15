--
-- eur_rpt.sql
--

-- Joins scores with eur_ms14.

CREATE OR REPLACE VIEW rpt AS
SELECT
s.prdate
,m.ydate
,score
,eur_g4 g4
FROM fxscores s, eur_ms14 m
WHERE s.ydate = m.ydate
AND s.pair='eur'
/

-- rpt
SELECT CORR(score,g4)FROM rpt WHERE score > 0.5;
SELECT TO_CHAR(ydate,'YYYY-MM'),CORR(score,g4)FROM rpt GROUP BY TO_CHAR(ydate,'YYYY-MM')ORDER BY TO_CHAR(ydate,'YYYY-MM');

SELECT
ROUND(score,1)score
,ROUND(AVG(g4),4)avg_gain
,COUNT(g4)cnt
,MIN(TO_CHAR(ydate,'YYYY-MM-DD'))min_ydate
,MAX(ydate)max_ydate
,CORR(score,g4)
FROM rpt
GROUP BY ROUND(score,1)
ORDER BY ROUND(score,1)
/

-- recently
SELECT
ROUND(score,1)score
,ROUND(AVG(g4),4)avg_gain
,COUNT(g4)cnt
,MIN(TO_CHAR(ydate,'YYYY-MM-DD'))min_ydate
,MAX(ydate)max_ydate
FROM rpt
WHERE ydate > sysdate - 3
GROUP BY ROUND(score,1)
ORDER BY ROUND(score,1)
/

-- Look at 0.65
-- I should see a positive gain
SELECT
ROUND(SUM(g4),4)sum_gain
,ROUND(AVG(g4),4)avg_gain
,COUNT(g4)cnt
,MIN(TO_CHAR(ydate,'YYYY-MM-DD'))min_ydate
,MAX(ydate)max_ydate
,CORR(score,g4)
FROM rpt
WHERE ydate > sysdate - 3
AND score >0.65
/

exit


