--
-- svmd_rpt.sql
--

-- I get the gain of each tkrdate:

CREATE OR REPLACE VIEW svmd10 AS
SELECT
tkr
,ydate
,tkr||ydate tkrdate
,LEAD(clse,1,NULL)OVER(PARTITION BY tkr ORDER BY ydate) - clse g1
FROM ystk 
WHERE ydate > '1990-01-01'
ORDER BY tkr,ydate
/

-- I join it with ystkscores:


CREATE OR REPLACE VIEW svmd12 AS
SELECT
v.tkr
,v.ydate
,v.tkrdate
,g1
,targ
,score
FROM svmd10 v, ystkscores s
WHERE v.tkrdate = s.tkrdate
ORDER BY v.tkrdate
/

-- rpt

SELECT
tkr
,targ
,ROUND(CORR(score,g1),2)crr
,COUNT(tkrdate)ccount
,ROUND(MIN(score),2)
,ROUND(AVG(score),2)
,ROUND(MAX(score),2)
FROM svmd12
GROUP BY tkr,targ
ORDER BY tkr,targ
/


SELECT
tkr
,targ
,ROUND(CORR(score,g1),2)crr
,COUNT(tkrdate)ccount
,ROUND(AVG(g1),2)avg_g1
,ROUND(MIN(g1),2)min_g1
,ROUND(STDDEV(g1),2)stddev_g1
,ROUND(MAX(g1),2)max_g1
FROM svmd12
WHERE score > 0.7
GROUP BY tkr,targ
ORDER BY tkr,targ
/

SELECT
tkr
,targ
,ROUND(CORR(score,g1),2)crr
,COUNT(tkrdate)ccount
,ROUND(AVG(g1),2)avg_g1
,ROUND(MIN(g1),2)min_g1
,ROUND(STDDEV(g1),2)stddev_g1
,ROUND(MAX(g1),2)max_g1
FROM svmd12
WHERE score < 0.3
GROUP BY tkr,targ
ORDER BY tkr,targ
/




