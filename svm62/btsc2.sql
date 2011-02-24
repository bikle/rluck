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
WHERE ydate > sysdate - 1
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
,m.g2
,m.g6
,m.g6-m.g2 g4
,CORR(l.score-s.score,g6)OVER(PARTITION BY l.pair ORDER BY l.ydate ROWS BETWEEN 12*24*1 PRECEDING AND CURRENT ROW)rnng_crr1
FROM svm62scores l,svm62scores s,btg10 m
WHERE l.targ='gatt'
AND   s.targ='gattn'
AND l.prdate = s.prdate
AND l.prdate = m.prdate
-- Speed things up:
AND l.ydate > sysdate - 1
AND s.ydate > sysdate - 1
/

ANALYZE TABLE btg12 COMPUTE STATISTICS;

-- Question:
-- How does g2 affect g4?

DROP TABLE btg14;
CREATE TABLE btg14 COMPRESS AS
SELECT
-- See if g2 is going right way or wrong way.
CASE WHEN SIGN(g2)*SIGN(score_diff)=1 THEN'g2_right_way'ELSE'g2_wrong_way'END sprod
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
FROM btg12
-- WHERE ABS(rscore_diff1)IN(0.7,0.8,0.9)
WHERE ABS(rscore_diff1)>0.6
AND SIGN(g2) != 0
AND ydate > sysdate - 1
AND rnng_crr1 > 0.1
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
FROM btg14
/

-- Start on looking at clumps of score_diff signals:

DROP TABLE btg16;
CREATE TABLE btg16 COMPRESS AS
SELECT
pair
,ydate
,prdate
,score_diff
,rscore_diff1
,g2
,g6
,g4
,rnng_crr1
,SIGN(score_diff)sgn_score_diff
FROM btg12
WHERE rnng_crr1 > 0.1
/

ANALYZE TABLE btg16 COMPUTE STATISTICS;

-- rpt

SELECT
pair
,sgn_score_diff
,rscore_diff1
,AVG(g4)avg_g4
,COUNT(ydate)ccount
FROM btg16
WHERE ABS(rscore_diff1)>0.6
AND ydate > sysdate - 1
GROUP BY pair,rscore_diff1,sgn_score_diff
ORDER BY pair,rscore_diff1,sgn_score_diff
/

-- aggregate:

SELECT
sgn_score_diff
,rscore_diff1
,AVG(g4)avg_g4
,COUNT(ydate)ccount
FROM btg16
WHERE ABS(rscore_diff1)>0.6
AND ydate > sysdate - 1
GROUP BY rscore_diff1,sgn_score_diff
ORDER BY rscore_diff1,sgn_score_diff
/

-- use aud_usd to help me see some clumping:

CREATE OR REPLACE VIEW btsc100 AS
SELECT
pair
,CASE WHEN rscore_diff1 >0.6 THEN 'buy'
      WHEN rscore_diff1 <-0.6 THEN 'sell'
ELSE NULL
END bors
,sgn_score_diff
,rscore_diff1
,g4
,ydate
FROM btg16
-- WHERE ABS(rscore_diff1)>0.6
-- AND ydate > sysdate - 1
WHERE ydate > sysdate - 1
AND rnng_crr1 > 0.1
-- AND pair = 'aud_usd'
ORDER BY pair,ydate
/

SELECT count(*) FROM btsc100;

-- Use LAG(),LEAD() to create the bors-clumps:

CREATE OR REPLACE VIEW btsc102 AS
SELECT
pair
,sgn_score_diff
,rscore_diff1
,g4
,ydate
,LAG(bors,1,NULL)OVER(PARTITION BY pair ORDER BY ydate)lag_bors
,bors
,LEAD(bors,1,NULL)OVER(PARTITION BY pair ORDER BY ydate)ld_bors
FROM btsc100
/

SELECT count(*) FROM btsc102;

SELECT * FROM btsc102

SELECT count(*) FROM btsc102 WHERE lag_bors = bors AND bors = ld_bors;

SELECT * FROM btsc102 WHERE lag_bors = bors AND bors = ld_bors;

-- aggregate around the clumps:

SELECT
pair
,sgn_score_diff
,AVG(g4)avg_g4
,COUNT(ydate)ccount
FROM btsc102 WHERE lag_bors = bors AND bors = ld_bors
AND ABS(rscore_diff1)>0.6
AND ydate > sysdate - 1
GROUP BY pair,sgn_score_diff
ORDER BY pair,sgn_score_diff
/

-- roll-up:
SELECT
sgn_score_diff
,AVG(g4)avg_g4
,COUNT(ydate)ccount
FROM btsc102 WHERE lag_bors = bors AND bors = ld_bors
AND ABS(rscore_diff1)>0.6
AND ydate > sysdate - 1
GROUP BY sgn_score_diff
ORDER BY sgn_score_diff
/

exit

