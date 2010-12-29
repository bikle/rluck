--
-- jpy_ocj_rpt.sql
--

-- Joins scores with jpy_ms6.

CREATE OR REPLACE VIEW jpy_rpt AS
SELECT
s.prdate
,m.ydate
,s.score
,g.score gscore
,ROUND(s.score,1)rscore
,ROUND(g.score,1)rgscore
,jpy_g6
FROM fxscores6 s, jpy_ms6 m, fxscores6_gattn g
WHERE s.ydate = m.ydate
AND s.pair='jpy'
AND s.score>0
AND g.pair='jpy'
AND g.ydate = m.ydate
/

-- rpt
SELECT 
COUNT(score)
,CORR(score,jpy_g6)
FROM jpy_rpt WHERE score > 0.5
/

SELECT
TO_CHAR(ydate,'YYYY-MM')
,COUNT(score)
,CORR(score,jpy_g6)
FROM jpy_rpt
GROUP BY TO_CHAR(ydate,'YYYY-MM')
ORDER BY TO_CHAR(ydate,'YYYY-MM')
/


SELECT
ROUND(score,1)score
,ROUND(AVG(jpy_g6),4)avg_gain
,COUNT(jpy_g6)cnt
,MIN(TO_CHAR(ydate,'YYYY-MM-DD'))min_ydate
,MAX(ydate)max_ydate
,CORR(score,jpy_g6)
FROM jpy_rpt
GROUP BY ROUND(score,1)
ORDER BY ROUND(score,1)


COLUMN rscore  FORMAT 999.9
COLUMN cnt     FORMAT 999999
COLUMN corr_sg FORMAT 999.99

SELECT
rscore
,ROUND(AVG(jpy_g6),4)    avg_jpy_g6
,COUNT(score)            cnt
,ROUND(MIN(jpy_g6),4)    min_jpy_g6
,ROUND(STDDEV(jpy_g6),4) std_jpy_g6
,ROUND(MAX(jpy_g6),4)    max_jpy_g6
,ROUND(CORR(score,jpy_g6),2)corr_sg
,MIN(ydate)        min_ydate
,MAX(ydate)        max_ydate
FROM jpy_rpt
GROUP BY rscore
ORDER BY rscore
/

SELECT
rscore
,ROUND(AVG(jpy_g6),4)    avg_jpy_g6
,COUNT(score)            cnt
,ROUND(MIN(jpy_g6),4)    min_jpy_g6
,ROUND(STDDEV(jpy_g6),4) std_jpy_g6
,ROUND(MAX(jpy_g6),4)    max_jpy_g6
,ROUND(CORR(score,jpy_g6),2)corr_sg
,MIN(ydate)        min_ydate
,MAX(ydate)        max_ydate
FROM jpy_rpt
WHERE gscore < 0.25
GROUP BY rscore
ORDER BY rscore
/

-- Look at short positions of usd_jpy:

SELECT
rgscore
,ROUND(AVG(jpy_g6),4)    avg_jpy_g6
,COUNT(gscore)            cnt
,ROUND(MIN(jpy_g6),4)    min_jpy_g6
,ROUND(STDDEV(jpy_g6),4) std_jpy_g6
,ROUND(MAX(jpy_g6),4)    max_jpy_g6
,ROUND(CORR(gscore,jpy_g6),2)corr_sg
,MIN(ydate)        min_ydate
,MAX(ydate)        max_ydate
FROM jpy_rpt
GROUP BY rgscore
ORDER BY rgscore
/

SELECT
rgscore
,ROUND(AVG(jpy_g6),4)    avg_jpy_g6
,COUNT(gscore)            cnt
,ROUND(MIN(jpy_g6),4)    min_jpy_g6
,ROUND(STDDEV(jpy_g6),4) std_jpy_g6
,ROUND(MAX(jpy_g6),4)    max_jpy_g6
,ROUND(CORR(gscore,jpy_g6),2)corr_sg
,MIN(ydate)        min_ydate
,MAX(ydate)        max_ydate
FROM jpy_rpt
WHERE score < 0.25
GROUP BY rgscore
ORDER BY rgscore
/

exit


