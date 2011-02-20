--
-- btg2.sql
--

-- I use this script to help me study relationship between scores, g2, and g6.

-- I start by getting the 6 hr gain (g6) and g2 for each prdate.
DROP TABLE btg10;
PURGE RECYCLEBIN;
CREATE TABLE btg10 COMPRESS AS
SELECT
prdate
,pair
,ydate
,(LEAD(clse,12*2,NULL)OVER(PARTITION BY pair ORDER BY ydate)-clse)/clse g2
,(LEAD(clse,12*6,NULL)OVER(PARTITION BY pair ORDER BY ydate)-clse)/clse g6
FROM di5min
WHERE ydate > sysdate - 122
AND clse > 0
ORDER BY pair,ydate
/

ANALYZE TABLE btg10 COMPUTE STATISTICS;

-- rpt
SELECT
pair
,AVG(g2)
,AVG(g6)
,CORR(g2,g6)
,MIN(ydate)
,COUNT(ydate)
,MAX(ydate)
FROM btg10
GROUP BY pair
ORDER BY pair
/

DROP TABLE btg12;
CREATE TABLE btg12 COMPRESS AS
SELECT
m.pair
,m.ydate
,m.prdate
,l.score-s.score          score_diff
,ROUND(l.score-s.score,1) rscore_diff1
,ROUND(l.score-s.score,2) rscore_diff2
,m.g2
,m.g6
,m.g6-m.g2 g4
FROM svm62scores l,svm62scores s,btg10 m
WHERE l.targ='gatt'
AND   s.targ='gattn'
AND l.prdate = s.prdate
AND l.prdate = m.prdate
-- Speed things up:
AND l.ydate > sysdate - 133
AND s.ydate > sysdate - 133
/


SELECT
pair
,rscore_diff1
,CORR(score_diff,g6)
,AVG(g2)
,AVG(g6)
,AVG(g4)
,CORR(g2,g6)
,CORR(g2,g4)
,MIN(ydate)
,COUNT(ydate)
,MAX(ydate)
FROM btg12
WHERE ABS(rscore_diff1)IN(0.7,0.8)
GROUP BY pair,rscore_diff1
ORDER BY pair,rscore_diff1
/

SELECT
SIGN(g2) * SIGN(score_diff) sprod
,rscore_diff1
,CORR(score_diff,g6)
,AVG(g2)
,AVG(g6)
,AVG(g4)
,CORR(g2,g6)
,CORR(g2,g4)
,MIN(ydate)
,COUNT(ydate)
,MAX(ydate)
FROM btg12
WHERE ABS(rscore_diff1)IN(0.7,0.8)
AND SIGN(g2) != 0
AND ABS(g2) < 0.0006
GROUP BY rscore_diff1,(SIGN(g2) * SIGN(score_diff))
ORDER BY rscore_diff1,(SIGN(g2) * SIGN(score_diff))
/

SELECT
SIGN(g2) * SIGN(score_diff) sprod
,rscore_diff1
,AVG(g4)avg_g4
,CORR(score_diff,g6)
,AVG(g2)
,AVG(g6)avg_g6
-- ,CORR(g2,g6)
,CORR(g2,g4)corr_g2g4
-- ,MIN(ydate)
,COUNT(ydate)ccount
-- ,MAX(ydate)
FROM btg12
-- WHERE ABS(rscore_diff1)IN(0.7,0.8,0.9)
WHERE ABS(rscore_diff1)>0.6
AND SIGN(g2) != 0
AND ABS(g2) > 0.0006
GROUP BY rscore_diff1,(SIGN(g2) * SIGN(score_diff))
ORDER BY rscore_diff1,(SIGN(g2) * SIGN(score_diff))
/

SELECT
SIGN(g2) * SIGN(score_diff) sprod
,rscore_diff1
,AVG(g4)avg_g4
,CORR(score_diff,g6)
,AVG(g2)
,AVG(g6)avg_g6
-- ,CORR(g2,g6)
,CORR(g2,g4)corr_g2g4
-- ,MIN(ydate)
,COUNT(ydate)ccount
-- ,MAX(ydate)
FROM btg12
-- WHERE ABS(rscore_diff1)IN(0.7,0.8,0.9)
WHERE ABS(rscore_diff1)>0.6
AND SIGN(g2) != 0
GROUP BY rscore_diff1,(SIGN(g2) * SIGN(score_diff))
ORDER BY rscore_diff1,(SIGN(g2) * SIGN(score_diff))
/

exit

