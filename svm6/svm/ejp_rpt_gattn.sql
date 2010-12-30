--
-- ejp_rpt_gattn.sql
--

-- Joins scores with ejp_ms6.

CREATE OR REPLACE VIEW ejp_rpt_gattn AS
SELECT
s.prdate
,m.ydate
,score
,ROUND(score,1)rscore
,ejp_g6
FROM fxscores6_gattn s, ejp_ms6 m
WHERE s.ydate = m.ydate
AND s.pair='ejp'
AND score>0
/

-- rpt
SELECT 
COUNT(score)
,CORR(score,ejp_g6)
FROM ejp_rpt_gattn WHERE score > 0.5
/

SELECT
TO_CHAR(ydate,'YYYY-MM')
,COUNT(score)
,CORR(score,ejp_g6)
FROM ejp_rpt_gattn
GROUP BY TO_CHAR(ydate,'YYYY-MM')
ORDER BY TO_CHAR(ydate,'YYYY-MM')
/


SELECT
ROUND(score,1)score
,ROUND(AVG(ejp_g6),4)avg_gain
,COUNT(ejp_g6)cnt
,MIN(TO_CHAR(ydate,'YYYY-MM-DD'))min_ydate
,MAX(ydate)max_ydate
,CORR(score,ejp_g6)
FROM ejp_rpt_gattn
GROUP BY ROUND(score,1)
ORDER BY ROUND(score,1)

-- recently
SELECT
ROUND(score,1)score
,ROUND(AVG(ejp_g6),4)avg_gain
,COUNT(ejp_g6)cnt
,MIN(TO_CHAR(ydate,'YYYY-MM-DD'))min_ydate
,MAX(ydate)max_ydate
FROM ejp_rpt_gattn
WHERE ydate > sysdate - 3
GROUP BY ROUND(score,1)
ORDER BY ROUND(score,1)


-- Look at 0.65
-- I should see a positive gain
SELECT
ROUND(SUM(ejp_g6),4)sum_gain
,ROUND(AVG(ejp_g6),4)avg_gain
,COUNT(ejp_g6)cnt
,MIN(TO_CHAR(ydate,'YYYY-MM-DD'))min_ydate
,MAX(ydate)max_ydate
,CORR(score,ejp_g6)
FROM ejp_rpt_gattn
WHERE ydate > sysdate - 3
AND score >0.65

COLUMN rscore  FORMAT 999.9
COLUMN cnt     FORMAT 999999
COLUMN corr_sg FORMAT 999.99

SELECT
rscore
,ROUND(AVG(ejp_g6),4)    avg_ejp_g6
,COUNT(score)            cnt
,ROUND(MIN(ejp_g6),4)    min_ejp_g6
,ROUND(STDDEV(ejp_g6),4) std_ejp_g6
,ROUND(MAX(ejp_g6),4)    max_ejp_g6
,ROUND(CORR(score,ejp_g6),2)corr_sg
,MIN(ydate)        min_ydate
,MAX(ydate)        max_ydate
FROM ejp_rpt_gattn
GROUP BY rscore
ORDER BY rscore
/

exit


