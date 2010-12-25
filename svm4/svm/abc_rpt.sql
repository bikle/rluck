--
-- abc_rpt.sql
--

-- Joins scores with abc_ms4.

CREATE OR REPLACE VIEW abc_rpt AS
SELECT
s.prdate
,m.ydate
,score
,ROUND(score,1)rscore
,abc_g4
FROM fxscores4 s, abc_ms4 m
WHERE s.ydate = m.ydate
AND s.pair='abc'
AND score>0
/

-- rpt
SELECT 
COUNT(score)
,CORR(score,abc_g4)
FROM abc_rpt WHERE score > 0.5
/

SELECT
TO_CHAR(ydate,'YYYY-MM')
,COUNT(score)
,CORR(score,abc_g4)
FROM abc_rpt
GROUP BY TO_CHAR(ydate,'YYYY-MM')
ORDER BY TO_CHAR(ydate,'YYYY-MM')
/


SELECT
ROUND(score,1)score
,ROUND(AVG(abc_g4),4)avg_gain
,COUNT(abc_g4)cnt
,MIN(TO_CHAR(ydate,'YYYY-MM-DD'))min_ydate
,MAX(ydate)max_ydate
,CORR(score,abc_g4)
FROM abc_rpt
GROUP BY ROUND(score,1)
ORDER BY ROUND(score,1)

-- recently
SELECT
ROUND(score,1)score
,ROUND(AVG(abc_g4),4)avg_gain
,COUNT(abc_g4)cnt
,MIN(TO_CHAR(ydate,'YYYY-MM-DD'))min_ydate
,MAX(ydate)max_ydate
FROM abc_rpt
WHERE ydate > sysdate - 3
GROUP BY ROUND(score,1)
ORDER BY ROUND(score,1)


-- Look at 0.65
-- I should see a positive gain
SELECT
ROUND(SUM(abc_g4),4)sum_gain
,ROUND(AVG(abc_g4),4)avg_gain
,COUNT(abc_g4)cnt
,MIN(TO_CHAR(ydate,'YYYY-MM-DD'))min_ydate
,MAX(ydate)max_ydate
,CORR(score,abc_g4)
FROM abc_rpt
WHERE ydate > sysdate - 3
AND score >0.65

COLUMN rscore  FORMAT 999.9
COLUMN cnt     FORMAT 999999
COLUMN corr_sg FORMAT 999.99

SELECT
rscore
,ROUND(AVG(abc_g4),4)    avg_abc_g4
,COUNT(score)            cnt
,ROUND(MIN(abc_g4),4)    min_abc_g4
,ROUND(STDDEV(abc_g4),4) std_abc_g4
,ROUND(MAX(abc_g4),4)    max_abc_g4
,ROUND(CORR(score,abc_g4),2)corr_sg
,MIN(ydate)        min_ydate
,MAX(ydate)        max_ydate
FROM abc_rpt
GROUP BY rscore
ORDER BY rscore
/

exit


