--
-- cad_rpt.sql
--

-- Joins scores with cad_ms14.

CREATE OR REPLACE VIEW cad_rpt AS
SELECT
s.prdate
,m.ydate
,score
,ROUND(score,1)rscore
,cad_g8
FROM fxscores8hp s, cad_ms14 m
WHERE s.ydate = m.ydate
AND s.pair='cad'
AND score>0
/

-- rpt
SELECT CORR(score,cad_g8)FROM cad_rpt WHERE score > 0.5;
SELECT
TO_CHAR(ydate,'YYYY-MM')
,CORR(score,cad_g8)
FROM cad_rpt
GROUP BY TO_CHAR(ydate,'YYYY-MM')
ORDER BY TO_CHAR(ydate,'YYYY-MM')
/


SELECT
ROUND(score,1)score
,ROUND(AVG(cad_g8),4)avg_gain
,COUNT(cad_g8)cnt
,MIN(TO_CHAR(ydate,'YYYY-MM-DD'))min_ydate
,MAX(ydate)max_ydate
,CORR(score,cad_g8)
FROM cad_rpt
GROUP BY ROUND(score,1)
ORDER BY ROUND(score,1)

-- recently
SELECT
ROUND(score,1)score
,ROUND(AVG(cad_g8),4)avg_gain
,COUNT(cad_g8)cnt
,MIN(TO_CHAR(ydate,'YYYY-MM-DD'))min_ydate
,MAX(ydate)max_ydate
FROM cad_rpt
WHERE ydate > sysdate - 3
GROUP BY ROUND(score,1)
ORDER BY ROUND(score,1)


-- Look at 0.65
-- I should see a positive gain
SELECT
ROUND(SUM(cad_g8),4)sum_gain
,ROUND(AVG(cad_g8),4)avg_gain
,COUNT(cad_g8)cnt
,MIN(TO_CHAR(ydate,'YYYY-MM-DD'))min_ydate
,MAX(ydate)max_ydate
,CORR(score,cad_g8)
FROM cad_rpt
WHERE ydate > sysdate - 3
AND score >0.65

COLUMN rscore  FORMAT 999.9
COLUMN cnt     FORMAT 999999
COLUMN corr_sg FORMAT 999.99

SELECT
rscore
,ROUND(AVG(cad_g8),4)    avg_cad_g8
,COUNT(score)            cnt
,ROUND(MIN(cad_g8),4)    min_cad_g8
,ROUND(STDDEV(cad_g8),4) std_cad_g8
,ROUND(MAX(cad_g8),4)    max_cad_g8
,ROUND(CORR(score,cad_g8),2)corr_sg
,MIN(ydate)        min_ydate
,MAX(ydate)        max_ydate
FROM cad_rpt
GROUP BY rscore
ORDER BY rscore
/

exit


