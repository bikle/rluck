--
-- btsc2.sql
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
,CORR(l.score-s.score,g6)OVER(PARTITION BY l.pair ORDER BY l.ydate ROWS BETWEEN 12*24*1 PRECEDING AND CURRENT ROW)rnng_crr1
,CORR(l.score-s.score,g6)OVER(PARTITION BY l.pair ORDER BY l.ydate ROWS BETWEEN 12*24*2 PRECEDING AND CURRENT ROW)rnng_crr2
,CORR(l.score-s.score,g6)OVER(PARTITION BY l.pair ORDER BY l.ydate ROWS BETWEEN 12*24*3 PRECEDING AND CURRENT ROW)rnng_crr3
FROM svm62scores l,svm62scores s,btg10 m
WHERE l.targ='gatt'
AND   s.targ='gattn'
AND l.prdate = s.prdate
AND l.prdate = m.prdate
-- Speed things up:
AND l.ydate > sysdate - 133
AND s.ydate > sysdate - 133
/

ANALYZE TABLE btg12 COMPUTE STATISTICS;

DROP TABLE btg14;
CREATE TABLE btg14 COMPRESS AS
SELECT
SIGN(g2) * SIGN(score_diff) sprod
,rscore_diff1
,AVG(g4)avg_g4
,CORR(score_diff,g6)corr_sg6
,AVG(g2)avg_g2
,AVG(g6)avg_g6
-- ,CORR(g2,g6)
,CORR(g2,g4)corr_g2g4
-- ,MIN(ydate)
,COUNT(ydate)ccount
-- ,MAX(ydate)
,AVG(rnng_crr1)avg_rnng_crr1
,AVG(rnng_crr2)avg_rnng_crr2
,AVG(rnng_crr3)avg_rnng_crr3
FROM btg12
-- WHERE ABS(rscore_diff1)IN(0.7,0.8,0.9)
WHERE ABS(rscore_diff1)>0.6
AND SIGN(g2) != 0
AND ydate > sysdate - 33
GROUP BY rscore_diff1,(SIGN(g2) * SIGN(score_diff))
ORDER BY rscore_diff1,(SIGN(g2) * SIGN(score_diff))
/

SELECT
sprod
,rscore_diff1
,avg_g4
,corr_sg6
,avg_g2
,avg_g6
,corr_g2g4
-- ,MIN(ydate)
,ccount
,avg_rnng_crr1
,avg_rnng_crr2
,avg_rnng_crr3
FROM btg14
/

DROP TABLE btg16;
CREATE TABLE btg16 COMPRESS AS
SELECT
pair
,ydate
,prdate
,score_diff
,rscore_diff1
,rscore_diff2
,g2
,g6
,g4
,rnng_crr1
,rnng_crr2
,rnng_crr3
,SIGN(score_diff)sgn_score_diff
FROM btg12
/

ANALYZE TABLE btg16 COMPUTE STATISTICS;

-- rpt

SELECT
sgn_score_diff
,rscore_diff1
,AVG(g4)avg_g4
,COUNT(ydate)ccount
FROM btg16
WHERE ABS(rscore_diff1)>0.6
AND ydate > sysdate - 33
GROUP BY rscore_diff1,sgn_score_diff
ORDER BY rscore_diff1,sgn_score_diff
/

SELECT
sgn_score_diff
,rscore_diff1
,AVG(g4)avg_g4
,COUNT(ydate)ccount
FROM btg16
WHERE ABS(rscore_diff1)>0.6
AND ydate > sysdate - 33
AND rnng_crr1 > 0.01
GROUP BY rscore_diff1,sgn_score_diff
ORDER BY rscore_diff1,sgn_score_diff
/

SELECT
sgn_score_diff
,rscore_diff1
,AVG(g4)avg_g4
,COUNT(ydate)ccount
FROM btg16
WHERE ABS(rscore_diff1)>0.6
AND ydate > sysdate - 33
AND rnng_crr2 > 0.01
GROUP BY rscore_diff1,sgn_score_diff
ORDER BY rscore_diff1,sgn_score_diff
/

SELECT
sgn_score_diff
,rscore_diff1
,AVG(g4)avg_g4
,COUNT(ydate)ccount
FROM btg16
WHERE ABS(rscore_diff1)>0.6
AND ydate > sysdate - 33
AND rnng_crr3 > 0.01
GROUP BY rscore_diff1,sgn_score_diff
ORDER BY rscore_diff1,sgn_score_diff
/

SELECT
sgn_score_diff
,rscore_diff1
,AVG(g4)avg_g4
,COUNT(ydate)ccount
FROM btg16
WHERE ABS(rscore_diff1)>0.6
AND ydate > sysdate - 33
AND rnng_crr1 > 0.01
AND rnng_crr2 > 0.01
AND rnng_crr3 > 0.01
GROUP BY rscore_diff1,sgn_score_diff
ORDER BY rscore_diff1,sgn_score_diff
/


SELECT
pair
,sgn_score_diff
,rscore_diff1
,AVG(g4)avg_g4
,COUNT(ydate)ccount
FROM btg16
WHERE ABS(rscore_diff1)>0.6
AND ydate > sysdate - 33
AND rnng_crr1 > 0.01
AND pair = 'usd_jpy'
GROUP BY pair,rscore_diff1,sgn_score_diff
ORDER BY pair,rscore_diff1,sgn_score_diff
/

SELECT
pair
,sgn_score_diff
,rscore_diff1
,AVG(g4)avg_g4
,COUNT(ydate)ccount
FROM btg16
WHERE ABS(rscore_diff1)>0.6
AND ydate > sysdate - 33
AND rnng_crr2 > 0.01
AND pair = 'usd_jpy'
GROUP BY pair,rscore_diff1,sgn_score_diff
ORDER BY pair,rscore_diff1,sgn_score_diff
/

SELECT
pair
,sgn_score_diff
,rscore_diff1
,AVG(g4)avg_g4
,COUNT(ydate)ccount
FROM btg16
WHERE ABS(rscore_diff1)>0.6
AND ydate > sysdate - 33
AND rnng_crr3 > 0.01
AND pair = 'usd_jpy'
GROUP BY pair,rscore_diff1,sgn_score_diff
ORDER BY pair,rscore_diff1,sgn_score_diff
/

exit

