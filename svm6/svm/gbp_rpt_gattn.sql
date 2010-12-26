--
-- gbp_rpt_gattn.sql
--

-- Joins scores with gbp_ms6.

CREATE OR REPLACE VIEW gbp_rpt_gattn AS
SELECT
s.prdate
,m.ydate
,score
,ROUND(score,1)rscore
,gbp_g6
FROM fxscores6_gattn s, gbp_ms6 m
WHERE s.ydate = m.ydate
AND s.pair='gbp'
AND score>0
/

-- rpt
SELECT 
COUNT(score)
,CORR(score,gbp_g6)
FROM gbp_rpt_gattn WHERE score > 0.5
/

SELECT
TO_CHAR(ydate,'YYYY-MM')
,COUNT(score)
,CORR(score,gbp_g6)
FROM gbp_rpt_gattn
GROUP BY TO_CHAR(ydate,'YYYY-MM')
ORDER BY TO_CHAR(ydate,'YYYY-MM')
/


SELECT
ROUND(score,1)score
,ROUND(AVG(gbp_g6),4)avg_gain
,COUNT(gbp_g6)cnt
,MIN(TO_CHAR(ydate,'YYYY-MM-DD'))min_ydate
,MAX(ydate)max_ydate
,CORR(score,gbp_g6)
FROM gbp_rpt_gattn
GROUP BY ROUND(score,1)
ORDER BY ROUND(score,1)

-- recently
SELECT
ROUND(score,1)score
,ROUND(AVG(gbp_g6),4)avg_gain
,COUNT(gbp_g6)cnt
,MIN(TO_CHAR(ydate,'YYYY-MM-DD'))min_ydate
,MAX(ydate)max_ydate
FROM gbp_rpt_gattn
WHERE ydate > sysdate - 3
GROUP BY ROUND(score,1)
ORDER BY ROUND(score,1)


-- Look at 0.65
-- I should see a positive gain
SELECT
ROUND(SUM(gbp_g6),4)sum_gain
,ROUND(AVG(gbp_g6),4)avg_gain
,COUNT(gbp_g6)cnt
,MIN(TO_CHAR(ydate,'YYYY-MM-DD'))min_ydate
,MAX(ydate)max_ydate
,CORR(score,gbp_g6)
FROM gbp_rpt_gattn
WHERE ydate > sysdate - 3
AND score >0.65

COLUMN rscore  FORMAT 999.9
COLUMN cnt     FORMAT 999999
COLUMN corr_sg FORMAT 999.99

SELECT
rscore
,ROUND(AVG(gbp_g6),4)    avg_gbp_g6
,COUNT(score)            cnt
,ROUND(MIN(gbp_g6),4)    min_gbp_g6
,ROUND(STDDEV(gbp_g6),4) std_gbp_g6
,ROUND(MAX(gbp_g6),4)    max_gbp_g6
,ROUND(CORR(score,gbp_g6),2)corr_sg
,MIN(ydate)        min_ydate
,MAX(ydate)        max_ydate
FROM gbp_rpt_gattn
GROUP BY rscore
ORDER BY rscore
/

exit


