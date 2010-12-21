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
,aud_g8
FROM fxscores8hp_gattn s, aud_ms14 m
WHERE s.ydate = m.ydate
AND s.pair='aud'
AND score>0
/

-- rpt
SELECT CORR(score,aud_g8)FROM aud_rpt WHERE score > 0.5;
SELECT
TO_CHAR(ydate,'YYYY-MM')
,CORR(score,aud_g8)
FROM aud_rpt
GROUP BY TO_CHAR(ydate,'YYYY-MM')
ORDER BY TO_CHAR(ydate,'YYYY-MM')
/


SELECT
ROUND(score,1)score
,ROUND(AVG(aud_g8),4)avg_gain
,COUNT(aud_g8)cnt
,MIN(TO_CHAR(ydate,'YYYY-MM-DD'))min_ydate
,MAX(ydate)max_ydate
,CORR(score,aud_g8)
FROM aud_rpt
GROUP BY ROUND(score,1)
ORDER BY ROUND(score,1)

-- recently
SELECT
ROUND(score,1)score
,ROUND(AVG(aud_g8),4)avg_gain
,COUNT(aud_g8)cnt
,MIN(TO_CHAR(ydate,'YYYY-MM-DD'))min_ydate
,MAX(ydate)max_ydate
FROM aud_rpt
WHERE ydate > sysdate - 3
GROUP BY ROUND(score,1)
ORDER BY ROUND(score,1)


-- Look at 0.65
-- I should see a positive gain
SELECT
ROUND(SUM(aud_g8),4)sum_gain
,ROUND(AVG(aud_g8),4)avg_gain
,COUNT(aud_g8)cnt
,MIN(TO_CHAR(ydate,'YYYY-MM-DD'))min_ydate
,MAX(ydate)max_ydate
,CORR(score,aud_g8)
FROM aud_rpt
WHERE ydate > sysdate - 3
AND score >0.65

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


--
-- aud_rpt.sql
--

-- Joins scores with aud_ms14.

CREATE OR REPLACE VIEW aud_rpt AS
SELECT
s.prdate
,m.ydate
,score
,ROUND(score,1)rscore
,aud_g8
FROM fxscores8hp s, aud_ms14 m
WHERE s.ydate = m.ydate
AND s.pair='aud'
AND score>0
/

-- rpt
SELECT CORR(score,aud_g8)FROM aud_rpt WHERE score > 0.5;
SELECT
TO_CHAR(ydate,'YYYY-MM')
,CORR(score,aud_g8)
FROM aud_rpt
GROUP BY TO_CHAR(ydate,'YYYY-MM')
ORDER BY TO_CHAR(ydate,'YYYY-MM')
/


SELECT
ROUND(score,1)score
,ROUND(AVG(aud_g8),4)avg_gain
,COUNT(aud_g8)cnt
,MIN(TO_CHAR(ydate,'YYYY-MM-DD'))min_ydate
,MAX(ydate)max_ydate
,CORR(score,aud_g8)
FROM aud_rpt
GROUP BY ROUND(score,1)
ORDER BY ROUND(score,1)

-- recently
SELECT
ROUND(score,1)score
,ROUND(AVG(aud_g8),4)avg_gain
,COUNT(aud_g8)cnt
,MIN(TO_CHAR(ydate,'YYYY-MM-DD'))min_ydate
,MAX(ydate)max_ydate
FROM aud_rpt
WHERE ydate > sysdate - 3
GROUP BY ROUND(score,1)
ORDER BY ROUND(score,1)


-- Look at 0.65
-- I should see a positive gain
SELECT
ROUND(SUM(aud_g8),4)sum_gain
,ROUND(AVG(aud_g8),4)avg_gain
,COUNT(aud_g8)cnt
,MIN(TO_CHAR(ydate,'YYYY-MM-DD'))min_ydate
,MAX(ydate)max_ydate
,CORR(score,aud_g8)
FROM aud_rpt
WHERE ydate > sysdate - 3
AND score >0.65

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


--
-- cad_rpt_gattn.sql
--

-- Joins scores with cad_ms14.

CREATE OR REPLACE VIEW cad_rpt AS
SELECT
s.prdate
,m.ydate
,score
,ROUND(score,1)rscore
,cad_g8
FROM fxscores8hp_gattn s, cad_ms14 m
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


--
-- chf_rpt_gattn.sql
--

-- Joins scores with chf_ms14.

CREATE OR REPLACE VIEW chf_rpt AS
SELECT
s.prdate
,m.ydate
,score
,ROUND(score,1)rscore
,chf_g8
FROM fxscores8hp_gattn s, chf_ms14 m
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


--
-- eur_rpt_gattn.sql
--

-- Joins scores with eur_ms14.

CREATE OR REPLACE VIEW eur_rpt AS
SELECT
s.prdate
,m.ydate
,score
,ROUND(score,1)rscore
,eur_g8
FROM fxscores8hp_gattn s, eur_ms14 m
WHERE s.ydate = m.ydate
AND s.pair='eur'
AND score>0
/

-- rpt
SELECT CORR(score,eur_g8)FROM eur_rpt WHERE score > 0.5;
SELECT
TO_CHAR(ydate,'YYYY-MM')
,CORR(score,eur_g8)
FROM eur_rpt
GROUP BY TO_CHAR(ydate,'YYYY-MM')
ORDER BY TO_CHAR(ydate,'YYYY-MM')
/


SELECT
ROUND(score,1)score
,ROUND(AVG(eur_g8),4)avg_gain
,COUNT(eur_g8)cnt
,MIN(TO_CHAR(ydate,'YYYY-MM-DD'))min_ydate
,MAX(ydate)max_ydate
,CORR(score,eur_g8)
FROM eur_rpt
GROUP BY ROUND(score,1)
ORDER BY ROUND(score,1)

-- recently
SELECT
ROUND(score,1)score
,ROUND(AVG(eur_g8),4)avg_gain
,COUNT(eur_g8)cnt
,MIN(TO_CHAR(ydate,'YYYY-MM-DD'))min_ydate
,MAX(ydate)max_ydate
FROM eur_rpt
WHERE ydate > sysdate - 3
GROUP BY ROUND(score,1)
ORDER BY ROUND(score,1)


-- Look at 0.65
-- I should see a positive gain
SELECT
ROUND(SUM(eur_g8),4)sum_gain
,ROUND(AVG(eur_g8),4)avg_gain
,COUNT(eur_g8)cnt
,MIN(TO_CHAR(ydate,'YYYY-MM-DD'))min_ydate
,MAX(ydate)max_ydate
,CORR(score,eur_g8)
FROM eur_rpt
WHERE ydate > sysdate - 3
AND score >0.65

COLUMN rscore  FORMAT 999.9
COLUMN cnt     FORMAT 999999
COLUMN corr_sg FORMAT 999.99

SELECT
rscore
,ROUND(AVG(eur_g8),4)    avg_eur_g8
,COUNT(score)            cnt
,ROUND(MIN(eur_g8),4)    min_eur_g8
,ROUND(STDDEV(eur_g8),4) std_eur_g8
,ROUND(MAX(eur_g8),4)    max_eur_g8
,ROUND(CORR(score,eur_g8),2)corr_sg
,MIN(ydate)        min_ydate
,MAX(ydate)        max_ydate
FROM eur_rpt
GROUP BY rscore
ORDER BY rscore
/

exit


--
-- eur_rpt.sql
--

-- Joins scores with eur_ms14.

CREATE OR REPLACE VIEW eur_rpt AS
SELECT
s.prdate
,m.ydate
,score
,ROUND(score,1)rscore
,eur_g8
FROM fxscores8hp s, eur_ms14 m
WHERE s.ydate = m.ydate
AND s.pair='eur'
AND score>0
/

-- rpt
SELECT CORR(score,eur_g8)FROM eur_rpt WHERE score > 0.5;
SELECT
TO_CHAR(ydate,'YYYY-MM')
,CORR(score,eur_g8)
FROM eur_rpt
GROUP BY TO_CHAR(ydate,'YYYY-MM')
ORDER BY TO_CHAR(ydate,'YYYY-MM')
/


SELECT
ROUND(score,1)score
,ROUND(AVG(eur_g8),4)avg_gain
,COUNT(eur_g8)cnt
,MIN(TO_CHAR(ydate,'YYYY-MM-DD'))min_ydate
,MAX(ydate)max_ydate
,CORR(score,eur_g8)
FROM eur_rpt
GROUP BY ROUND(score,1)
ORDER BY ROUND(score,1)

-- recently
SELECT
ROUND(score,1)score
,ROUND(AVG(eur_g8),4)avg_gain
,COUNT(eur_g8)cnt
,MIN(TO_CHAR(ydate,'YYYY-MM-DD'))min_ydate
,MAX(ydate)max_ydate
FROM eur_rpt
WHERE ydate > sysdate - 3
GROUP BY ROUND(score,1)
ORDER BY ROUND(score,1)


-- Look at 0.65
-- I should see a positive gain
SELECT
ROUND(SUM(eur_g8),4)sum_gain
,ROUND(AVG(eur_g8),4)avg_gain
,COUNT(eur_g8)cnt
,MIN(TO_CHAR(ydate,'YYYY-MM-DD'))min_ydate
,MAX(ydate)max_ydate
,CORR(score,eur_g8)
FROM eur_rpt
WHERE ydate > sysdate - 3
AND score >0.65

COLUMN rscore  FORMAT 999.9
COLUMN cnt     FORMAT 999999
COLUMN corr_sg FORMAT 999.99

SELECT
rscore
,ROUND(AVG(eur_g8),4)    avg_eur_g8
,COUNT(score)            cnt
,ROUND(MIN(eur_g8),4)    min_eur_g8
,ROUND(STDDEV(eur_g8),4) std_eur_g8
,ROUND(MAX(eur_g8),4)    max_eur_g8
,ROUND(CORR(score,eur_g8),2)corr_sg
,MIN(ydate)        min_ydate
,MAX(ydate)        max_ydate
FROM eur_rpt
GROUP BY rscore
ORDER BY rscore
/

exit


--
-- gbp_rpt_gattn.sql
--

-- Joins scores with gbp_ms14.

CREATE OR REPLACE VIEW gbp_rpt AS
SELECT
s.prdate
,m.ydate
,score
,ROUND(score,1)rscore
,gbp_g8
FROM fxscores8hp_gattn s, gbp_ms14 m
WHERE s.ydate = m.ydate
AND s.pair='gbp'
AND score>0
/

-- rpt
SELECT CORR(score,gbp_g8)FROM gbp_rpt WHERE score > 0.5;
SELECT
TO_CHAR(ydate,'YYYY-MM')
,CORR(score,gbp_g8)
FROM gbp_rpt
GROUP BY TO_CHAR(ydate,'YYYY-MM')
ORDER BY TO_CHAR(ydate,'YYYY-MM')
/


SELECT
ROUND(score,1)score
,ROUND(AVG(gbp_g8),4)avg_gain
,COUNT(gbp_g8)cnt
,MIN(TO_CHAR(ydate,'YYYY-MM-DD'))min_ydate
,MAX(ydate)max_ydate
,CORR(score,gbp_g8)
FROM gbp_rpt
GROUP BY ROUND(score,1)
ORDER BY ROUND(score,1)

-- recently
SELECT
ROUND(score,1)score
,ROUND(AVG(gbp_g8),4)avg_gain
,COUNT(gbp_g8)cnt
,MIN(TO_CHAR(ydate,'YYYY-MM-DD'))min_ydate
,MAX(ydate)max_ydate
FROM gbp_rpt
WHERE ydate > sysdate - 3
GROUP BY ROUND(score,1)
ORDER BY ROUND(score,1)


-- Look at 0.65
-- I should see a positive gain
SELECT
ROUND(SUM(gbp_g8),4)sum_gain
,ROUND(AVG(gbp_g8),4)avg_gain
,COUNT(gbp_g8)cnt
,MIN(TO_CHAR(ydate,'YYYY-MM-DD'))min_ydate
,MAX(ydate)max_ydate
,CORR(score,gbp_g8)
FROM gbp_rpt
WHERE ydate > sysdate - 3
AND score >0.65

COLUMN rscore  FORMAT 999.9
COLUMN cnt     FORMAT 999999
COLUMN corr_sg FORMAT 999.99

SELECT
rscore
,ROUND(AVG(gbp_g8),4)    avg_gbp_g8
,COUNT(score)            cnt
,ROUND(MIN(gbp_g8),4)    min_gbp_g8
,ROUND(STDDEV(gbp_g8),4) std_gbp_g8
,ROUND(MAX(gbp_g8),4)    max_gbp_g8
,ROUND(CORR(score,gbp_g8),2)corr_sg
,MIN(ydate)        min_ydate
,MAX(ydate)        max_ydate
FROM gbp_rpt
GROUP BY rscore
ORDER BY rscore
/

exit


--
-- gbp_rpt.sql
--

-- Joins scores with gbp_ms14.

CREATE OR REPLACE VIEW gbp_rpt AS
SELECT
s.prdate
,m.ydate
,score
,ROUND(score,1)rscore
,gbp_g8
FROM fxscores8hp s, gbp_ms14 m
WHERE s.ydate = m.ydate
AND s.pair='gbp'
AND score>0
/

-- rpt
SELECT CORR(score,gbp_g8)FROM gbp_rpt WHERE score > 0.5;
SELECT
TO_CHAR(ydate,'YYYY-MM')
,CORR(score,gbp_g8)
FROM gbp_rpt
GROUP BY TO_CHAR(ydate,'YYYY-MM')
ORDER BY TO_CHAR(ydate,'YYYY-MM')
/


SELECT
ROUND(score,1)score
,ROUND(AVG(gbp_g8),4)avg_gain
,COUNT(gbp_g8)cnt
,MIN(TO_CHAR(ydate,'YYYY-MM-DD'))min_ydate
,MAX(ydate)max_ydate
,CORR(score,gbp_g8)
FROM gbp_rpt
GROUP BY ROUND(score,1)
ORDER BY ROUND(score,1)

-- recently
SELECT
ROUND(score,1)score
,ROUND(AVG(gbp_g8),4)avg_gain
,COUNT(gbp_g8)cnt
,MIN(TO_CHAR(ydate,'YYYY-MM-DD'))min_ydate
,MAX(ydate)max_ydate
FROM gbp_rpt
WHERE ydate > sysdate - 3
GROUP BY ROUND(score,1)
ORDER BY ROUND(score,1)


-- Look at 0.65
-- I should see a positive gain
SELECT
ROUND(SUM(gbp_g8),4)sum_gain
,ROUND(AVG(gbp_g8),4)avg_gain
,COUNT(gbp_g8)cnt
,MIN(TO_CHAR(ydate,'YYYY-MM-DD'))min_ydate
,MAX(ydate)max_ydate
,CORR(score,gbp_g8)
FROM gbp_rpt
WHERE ydate > sysdate - 3
AND score >0.65

COLUMN rscore  FORMAT 999.9
COLUMN cnt     FORMAT 999999
COLUMN corr_sg FORMAT 999.99

SELECT
rscore
,ROUND(AVG(gbp_g8),4)    avg_gbp_g8
,COUNT(score)            cnt
,ROUND(MIN(gbp_g8),4)    min_gbp_g8
,ROUND(STDDEV(gbp_g8),4) std_gbp_g8
,ROUND(MAX(gbp_g8),4)    max_gbp_g8
,ROUND(CORR(score,gbp_g8),2)corr_sg
,MIN(ydate)        min_ydate
,MAX(ydate)        max_ydate
FROM gbp_rpt
GROUP BY rscore
ORDER BY rscore
/

exit


--
-- jpy_rpt_gattn.sql
--

-- Joins scores with jpy_ms14.

CREATE OR REPLACE VIEW jpy_rpt AS
SELECT
s.prdate
,m.ydate
,score
,ROUND(score,1)rscore
,jpy_g8
FROM fxscores8hp_gattn s, jpy_ms14 m
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


