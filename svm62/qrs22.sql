--
-- qrs22.sql
--

-- I use this script to look at recent scores.
-- Inspiration comes from qrs.sql and btsc2.sql

DROP TABLE qrs10;
PURGE RECYCLEBIN;
CREATE TABLE qrs10 COMPRESS AS
SELECT
pair
,ydate
,clse
,prdate
,(LEAD(clse,12*2,NULL)OVER(PARTITION BY pair ORDER BY ydate)-clse)/clse g2
,(LEAD(clse,12*6,NULL)OVER(PARTITION BY pair ORDER BY ydate)-clse)/clse g6
FROM di5min
WHERE ydate > sysdate - 9
AND clse > 0
ORDER BY pair,ydate
/

ANALYZE TABLE qrs10 COMPUTE STATISTICS;

DROP TABLE qrs12;
CREATE TABLE qrs12 COMPRESS AS
SELECT
m.pair
,m.ydate
,m.clse
,l.score-s.score score_diff
,ROUND(l.score-s.score,1) rscore_diff1
,ROUND(l.score-s.score,2) rscore_diff2
,m.g2
,m.g6
,m.g6-m.g2 g4
,COVAR_POP(l.score-s.score,g6)OVER(PARTITION BY l.pair ORDER BY l.ydate ROWS BETWEEN 12*24*1 PRECEDING AND CURRENT ROW)rnng_crr1
FROM svm62scores l,svm62scores s,qrs10 m
WHERE l.targ='gatt'
AND   s.targ='gattn'
AND l.prdate = s.prdate
AND l.prdate = m.prdate
-- Speed things up:
AND l.ydate > sysdate - 5
AND s.ydate > sysdate - 5
/

-- SELECT pair,COVAR_POP(score_diff,g6)*100123 from qrs12 group by pair;

ANALYZE TABLE qrs12 COMPUTE STATISTICS;

select count(*)from
(
SELECT
pair
,ydate
,rscore_diff2
,g2
,ROUND(rnng_crr1,2)      rnng_crr1
,(sysdate - ydate)*24*60 minutes_age
FROM qrs12
WHERE rnng_crr1*100123 > 0.0
AND ydate > sysdate - 4/24
ORDER BY pair,ydate
)
/

select count(*)from
(
SELECT
pair
,rscore_diff2
,g2
,ROUND(rnng_crr1,2)      rnng_crr1
,(sysdate - ydate)*24*60 minutes_age
FROM qrs12
WHERE rnng_crr1*100123 > 0.0
AND ydate > sysdate - 4/24
AND ABS(rscore_diff2) > 0.6
ORDER BY pair,ydate
)
/

COLUMN avg_g6       FORMAT 9.9999
COLUMN sum_g6       FORMAT 9.9999
COLUMN stddev_g6    FORMAT 9.9999
COLUMN sharpe_ratio FORMAT 99.9999

SELECT
SIGN(rscore_diff2)sign_score_diff
,pair
,COUNT(pair)count_pair
,AVG(g6)            avg_g6
,STDDEV(g6)         stddev_g6
,AVG(g6)/STDDEV(g6) sharpe_ratio
,SUM(g6)            sum_g6
FROM qrs12
WHERE rnng_crr1*100123 > 0.0
AND ABS(rscore_diff2) > 0.6
AND ydate > sysdate - 15
GROUP BY SIGN(rscore_diff2),pair
HAVING STDDEV(g6) > 0
ORDER BY SIGN(rscore_diff2),pair

SELECT
SIGN(rscore_diff2)sign_score_diff
,pair
,COUNT(pair)count_pair
,AVG(g6)            avg_g6
,STDDEV(g6)         stddev_g6
,AVG(g6)/STDDEV(g6) sharpe_ratio
,SUM(g6)            sum_g6
FROM qrs12
WHERE rnng_crr1*100123 > 0.0
AND ABS(rscore_diff2) > 0.5
AND ydate > sysdate - 15
GROUP BY SIGN(rscore_diff2),pair
HAVING STDDEV(g6) > 0
ORDER BY SIGN(rscore_diff2),pair
/

SELECT
pair
,ydate
,CASE WHEN rscore_diff2<0 THEN'sell'ELSE'buy'END bors
,ROUND(clse,4)clse
,rscore_diff2
,ROUND(g2,4)g2
,ROUND(rnng_crr1,2)      rnng_crr1
,(sysdate - ydate)*24*60 minutes_age
--,ydate + 6/24 cls_date
,TO_CHAR(ydate + 6/24,'YYYYMMDD_HH24:MI:SS')||'_GMT' cls_str
FROM qrs12
WHERE rnng_crr1*100123 > 0.0
AND ydate > sysdate - 4/24
AND ABS(rscore_diff2) > 0.5
ORDER BY pair,ydate
/

exit
