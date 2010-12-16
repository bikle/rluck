--
-- qry_sjm.sql
--

-- I use this script to look at join of fxscores and chf_ms10

SET LINES 66
DESC chf_ms10
DESC fxscores
DESC fxscores_gattn
SET LINES 166

SELECT COUNT(chf_g4)FROM chf_ms10;
SELECT COUNT(prdate)FROM fxscores;
SELECT COUNT(prdate)FROM fxscores_gattn;
SELECT COUNT(prdate)FROM fxscores_gattn where rundate>sysdate -2;

-- Look at Dollar-bullish predictions that usd_chf will go up:

SELECT
rscore
,ROUND(AVG(chf_g4),4)    avg_chf_g4
,COUNT(score)            cnt
,ROUND(MIN(chf_g4),4)    min_chf_g4
,ROUND(STDDEV(chf_g4),4) std_chf_g4
,ROUND(MAX(chf_g4),4)    max_chf_g4
,ROUND(CORR(score,chf_g4),2)corr_sg
,MIN(ydate)        min_ydate
,MAX(ydate)        max_ydate
FROM
(
  SELECT
  score
  ,ROUND(score,1)rscore
  ,chf_g4
  ,m.ydate
  FROM chf_ms10 m, fxscores s
  WHERE 'chf'||m.ydate = s.prdate
  AND score>0
)
GROUP BY rscore
ORDER BY rscore
/

-- Look at Dollar-bearish predictions that usd_chf will go down:

SELECT
rscore
,ROUND(AVG(chf_g4),4)    avg_chf_g4
,COUNT(score)            cnt
,ROUND(MIN(chf_g4),4)    min_chf_g4
,ROUND(STDDEV(chf_g4),4) std_chf_g4
,ROUND(MAX(chf_g4),4)    max_chf_g4
,ROUND(CORR(score,chf_g4),2)corr_sg
,MIN(ydate)        min_ydate
,MAX(ydate)        max_ydate
FROM
(
  SELECT
  score
  ,ROUND(score,1)rscore
  ,chf_g4
  ,m.ydate
  FROM chf_ms10 m, fxscores_gattn s
  WHERE 'chf'||m.ydate = s.prdate
  AND score>0
)
GROUP BY rscore
ORDER BY rscore
/

exit
