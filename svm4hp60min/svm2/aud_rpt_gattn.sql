--
-- aud_rpt_gattn.sql
--

-- Joins scores with aud_ms14.

CREATE OR REPLACE VIEW aud_rpt AS
SELECT
s.prdate
,m.ydate
,score
,ROUND(score,1)rscore
,aud_g4
FROM fxscores_gattn s, aud_ms14 m
WHERE s.ydate = m.ydate
AND s.pair='aud'
AND score>0
/

-- rpt
SELECT CORR(score,aud_g4)FROM aud_rpt WHERE score > 0.5;
SELECT
TO_CHAR(ydate,'YYYY-MM')
,CORR(score,aud_g4)
FROM aud_rpt
GROUP BY TO_CHAR(ydate,'YYYY-MM')
ORDER BY TO_CHAR(ydate,'YYYY-MM')
/


SELECT
ROUND(score,1)score
,ROUND(AVG(aud_g4),4)avg_gain
,COUNT(aud_g4)cnt
,MIN(TO_CHAR(ydate,'YYYY-MM-DD'))min_ydate
,MAX(ydate)max_ydate
,CORR(score,aud_g4)
FROM aud_rpt
GROUP BY ROUND(score,1)
ORDER BY ROUND(score,1)

-- recently
SELECT
ROUND(score,1)score
,ROUND(AVG(aud_g4),4)avg_gain
,COUNT(aud_g4)cnt
,MIN(TO_CHAR(ydate,'YYYY-MM-DD'))min_ydate
,MAX(ydate)max_ydate
FROM aud_rpt
WHERE ydate > sysdate - 3
GROUP BY ROUND(score,1)
ORDER BY ROUND(score,1)


-- Look at 0.65
-- I should see a positive gain
SELECT
ROUND(SUM(aud_g4),4)sum_gain
,ROUND(AVG(aud_g4),4)avg_gain
,COUNT(aud_g4)cnt
,MIN(TO_CHAR(ydate,'YYYY-MM-DD'))min_ydate
,MAX(ydate)max_ydate
,CORR(score,aud_g4)
FROM aud_rpt
WHERE ydate > sysdate - 3
AND score >0.65

COLUMN rscore  FORMAT 999.9
COLUMN cnt     FORMAT 999999
COLUMN corr_sg FORMAT 999.99

SELECT
rscore
,ROUND(AVG(aud_g4),4)    avg_aud_g4
,COUNT(score)            cnt
,ROUND(MIN(aud_g4),4)    min_aud_g4
,ROUND(STDDEV(aud_g4),4) std_aud_g4
,ROUND(MAX(aud_g4),4)    max_aud_g4
,ROUND(CORR(score,aud_g4),2)corr_sg
,MIN(ydate)        min_ydate
,MAX(ydate)        max_ydate
FROM aud_rpt
GROUP BY rscore
ORDER BY rscore
/

exit


