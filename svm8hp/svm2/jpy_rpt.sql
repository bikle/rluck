--
-- jpy_rpt.sql
--

-- Joins scores with jpy_ms14.

CREATE OR REPLACE VIEW jpy_rpt AS
SELECT
s.prdate
,m.ydate
,score
,ROUND(score,1)rscore
,jpy_g8
FROM fxscores8hp s, jpy_ms14 m
WHERE s.ydate = m.ydate
AND s.pair='jpy'
AND score>0
/

-- rpt
SELECT CORR(score,jpy_g8)FROM jpy_rpt WHERE score > 0.5;
SELECT
TO_CHAR(ydate,'YYYY-MM')
,CORR(score,jpy_g8)
FROM jpy_rpt
GROUP BY TO_CHAR(ydate,'YYYY-MM')
ORDER BY TO_CHAR(ydate,'YYYY-MM')
/


SELECT
ROUND(score,1)score
,ROUND(AVG(jpy_g8),4)avg_gain
,COUNT(jpy_g8)cnt
,MIN(TO_CHAR(ydate,'YYYY-MM-DD'))min_ydate
,MAX(ydate)max_ydate
,CORR(score,jpy_g8)
FROM jpy_rpt
GROUP BY ROUND(score,1)
ORDER BY ROUND(score,1)

-- recently
SELECT
ROUND(score,1)score
,ROUND(AVG(jpy_g8),4)avg_gain
,COUNT(jpy_g8)cnt
,MIN(TO_CHAR(ydate,'YYYY-MM-DD'))min_ydate
,MAX(ydate)max_ydate
FROM jpy_rpt
WHERE ydate > sysdate - 3
GROUP BY ROUND(score,1)
ORDER BY ROUND(score,1)


-- Look at 0.65
-- I should see a positive gain
SELECT
ROUND(SUM(jpy_g8),4)sum_gain
,ROUND(AVG(jpy_g8),4)avg_gain
,COUNT(jpy_g8)cnt
,MIN(TO_CHAR(ydate,'YYYY-MM-DD'))min_ydate
,MAX(ydate)max_ydate
,CORR(score,jpy_g8)
FROM jpy_rpt
WHERE ydate > sysdate - 3
AND score >0.65

COLUMN rscore  FORMAT 999.9
COLUMN cnt     FORMAT 999999
COLUMN corr_sg FORMAT 999.99

SELECT
rscore
,ROUND(AVG(jpy_g8),4)    avg_jpy_g8
,COUNT(score)            cnt
,ROUND(MIN(jpy_g8),4)    min_jpy_g8
,ROUND(STDDEV(jpy_g8),4) std_jpy_g8
,ROUND(MAX(jpy_g8),4)    max_jpy_g8
,ROUND(CORR(score,jpy_g8),2)corr_sg
,MIN(ydate)        min_ydate
,MAX(ydate)        max_ydate
FROM jpy_rpt
GROUP BY rscore
ORDER BY rscore
/

exit


