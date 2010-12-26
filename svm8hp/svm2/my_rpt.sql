--
-- aud_rpt.sql
--

-- Joins scores with aud_ms14.

CREATE OR REPLACE VIEW aud_rpt AS
SELECT
s.prdate
,m.ydate
,s.score
,ROUND(s.score,1)rscore
,aud_g8
FROM fxscores8hp s, aud_ms14 m, fxscores6 f
WHERE s.ydate = m.ydate
AND s.ydate = f.ydate
AND s.pair='aud'
AND f.pair='aud'
AND s.score>0
/

-- rpt
SELECT count(score),CORR(score,aud_g8)FROM aud_rpt WHERE score > 0.5;

SELECT
TO_CHAR(ydate,'YYYY-MM')
,count(score)
,CORR(score,aud_g8)
FROM aud_rpt
GROUP BY TO_CHAR(ydate,'YYYY-MM')
ORDER BY TO_CHAR(ydate,'YYYY-MM')
/


COLUMN rscore  FORMAT 999.9
COLUMN cnt     FORMAT 999999
COLUMN corr_sg FORMAT 999.99

SELECT
rscore
,ROUND(AVG(aud_g8),4)    avg_aud_g8
,COUNT(score)            cnt
,ROUND(MIN(aud_g8),4)    min_aud_g8
,ROUND(STDDEV(aud_g8),4) std_aud_g8
,ROUND(MAX(aud_g8),4)    max_aud_g8
,ROUND(CORR(score,aud_g8),2)corr_sg
,MIN(ydate)        min_ydate
,MAX(ydate)        max_ydate
FROM aud_rpt
GROUP BY rscore
ORDER BY rscore
/

exit


