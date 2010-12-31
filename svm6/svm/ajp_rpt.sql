--
-- ajp_rpt.sql
--

-- Joins scores with ajp_ms6.

CREATE OR REPLACE VIEW ajp_rpt AS
SELECT
s.prdate
,m.ydate
,s.score score_long
,g.score score_short
,ROUND(s.score,1)rscore_long
,ROUND(g.score,1)rscore_short
,ajp_g6
FROM fxscores6 s, ajp_ms6 m, fxscores6_gattn g
WHERE s.ydate = m.ydate
AND s.pair='ajp'
AND s.score>0
AND s.ydate = g.ydate
AND s.pair = g.pair
/

SELECT
TO_CHAR(ydate,'YYYY-MM')
,COUNT(score_long)
,CORR(score_long,ajp_g6)
,CORR(score_short,ajp_g6)
FROM ajp_rpt
GROUP BY TO_CHAR(ydate,'YYYY-MM')
ORDER BY TO_CHAR(ydate,'YYYY-MM')
/


SELECT
ROUND(score_long,1)score_long
,ROUND(AVG(ajp_g6),4)avg_gain
,COUNT(ajp_g6)cnt
,MIN(TO_CHAR(ydate,'YYYY-MM-DD'))min_ydate
,MAX(ydate)max_ydate
,CORR(score_long,ajp_g6)
,CORR(score_short,ajp_g6)
FROM ajp_rpt
GROUP BY ROUND(score_long,1)
ORDER BY ROUND(score_long,1)
/

COLUMN rscore_long  FORMAT 999.9
COLUMN rscore_short  FORMAT 999.9
COLUMN cnt     FORMAT 999999
COLUMN corr_sg FORMAT 999.99

SELECT
rscore_long
,ROUND(AVG(ajp_g6),4)    avg_ajp_g6
,COUNT(score_long)            cnt
,ROUND(MIN(ajp_g6),4)    min_ajp_g6
,ROUND(STDDEV(ajp_g6),4) std_ajp_g6
,ROUND(MAX(ajp_g6),4)    max_ajp_g6
,ROUND(CORR(score_long,ajp_g6),2)corr_sg
,MIN(ydate)        min_ydate
,MAX(ydate)        max_ydate
FROM ajp_rpt
GROUP BY rscore_long
ORDER BY rscore_long
/

-- See if constraining by score_short helps:

SELECT
rscore_long
,ROUND(AVG(ajp_g6),4)    avg_ajp_g6
,COUNT(score_long)            cnt
,ROUND(MIN(ajp_g6),4)    min_ajp_g6
,ROUND(STDDEV(ajp_g6),4) std_ajp_g6
,ROUND(MAX(ajp_g6),4)    max_ajp_g6
,ROUND(CORR(score_long,ajp_g6),2)corr_sg
,MIN(ydate)        min_ydate
,MAX(ydate)        max_ydate
FROM ajp_rpt
WHERE score_short < 0.2
GROUP BY rscore_long
ORDER BY rscore_long
/

--
-- Look at score_short.
--

SELECT
rscore_short
,ROUND(AVG(ajp_g6),4)    avg_ajp_g6
,COUNT(score_short)            cnt
,ROUND(MIN(ajp_g6),4)    min_ajp_g6
,ROUND(STDDEV(ajp_g6),4) std_ajp_g6
,ROUND(MAX(ajp_g6),4)    max_ajp_g6
,ROUND(CORR(score_short,ajp_g6),2)corr_sg
,MIN(ydate)        min_ydate
,MAX(ydate)        max_ydate
FROM ajp_rpt
GROUP BY rscore_short
ORDER BY rscore_short
/

-- See if constraining by score_long helps:

SELECT
rscore_short
,ROUND(AVG(ajp_g6),4)    avg_ajp_g6
,COUNT(score_short)            cnt
,ROUND(MIN(ajp_g6),4)    min_ajp_g6
,ROUND(STDDEV(ajp_g6),4) std_ajp_g6
,ROUND(MAX(ajp_g6),4)    max_ajp_g6
,ROUND(CORR(score_short,ajp_g6),2)corr_sg
,MIN(ydate)        min_ydate
,MAX(ydate)        max_ydate
FROM ajp_rpt
WHERE score_long < 0.2
GROUP BY rscore_short
ORDER BY rscore_short
/

exit


