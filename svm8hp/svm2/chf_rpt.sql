--
-- chf_rpt.sql
--

-- Joins scores with chf_ms14.

CREATE OR REPLACE VIEW chf_rpt AS
SELECT
s.prdate
,m.ydate
,score
,ROUND(score,1)rscore
,chf_g8
FROM fxscores8hp s, chf_ms14 m
WHERE s.ydate = m.ydate
AND s.pair='chf'
AND score>0
/

-- rpt
SELECT CORR(score,chf_g8)FROM chf_rpt WHERE score > 0.5;
SELECT
TO_CHAR(ydate,'YYYY-MM')
,CORR(score,chf_g8)
FROM chf_rpt
GROUP BY TO_CHAR(ydate,'YYYY-MM')
ORDER BY TO_CHAR(ydate,'YYYY-MM')
/


SELECT
ROUND(score,1)score
,ROUND(AVG(chf_g8),4)avg_gain
,COUNT(chf_g8)cnt
,MIN(TO_CHAR(ydate,'YYYY-MM-DD'))min_ydate
,MAX(ydate)max_ydate
,CORR(score,chf_g8)
FROM chf_rpt
GROUP BY ROUND(score,1)
ORDER BY ROUND(score,1)

-- recently
SELECT
ROUND(score,1)score
,ROUND(AVG(chf_g8),4)avg_gain
,COUNT(chf_g8)cnt
,MIN(TO_CHAR(ydate,'YYYY-MM-DD'))min_ydate
,MAX(ydate)max_ydate
FROM chf_rpt
WHERE ydate > sysdate - 3
GROUP BY ROUND(score,1)
ORDER BY ROUND(score,1)


-- Look at 0.65
-- I should see a positive gain
SELECT
ROUND(SUM(chf_g8),4)sum_gain
,ROUND(AVG(chf_g8),4)avg_gain
,COUNT(chf_g8)cnt
,MIN(TO_CHAR(ydate,'YYYY-MM-DD'))min_ydate
,MAX(ydate)max_ydate
,CORR(score,chf_g8)
FROM chf_rpt
WHERE ydate > sysdate - 3
AND score >0.65

COLUMN rscore  FORMAT 999.9
COLUMN cnt     FORMAT 999999
COLUMN corr_sg FORMAT 999.99

SELECT
rscore
,ROUND(AVG(chf_g8),4)    avg_chf_g8
,COUNT(score)            cnt
,ROUND(MIN(chf_g8),4)    min_chf_g8
,ROUND(STDDEV(chf_g8),4) std_chf_g8
,ROUND(MAX(chf_g8),4)    max_chf_g8
,ROUND(CORR(score,chf_g8),2)corr_sg
,MIN(ydate)        min_ydate
,MAX(ydate)        max_ydate
FROM chf_rpt
GROUP BY rscore
ORDER BY rscore
/

exit


