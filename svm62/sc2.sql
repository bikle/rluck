--
-- sc2.sql
--

-- I use this script to help me see recent CORR() between score and gain.

-- I start by getting the 6 hr gain for each prdate.
DROP TABLE scc10_t;
PURGE RECYCLEBIN;
CREATE TABLE scc10_t COMPRESS AS
SELECT
prdate
,pair
,ydate
,(LEAD(clse,12*6,NULL)OVER(PARTITION BY pair ORDER BY ydate)-clse)/clse g6
FROM di5min
WHERE ydate > sysdate - 122
AND clse > 0
ORDER BY pair,ydate
/

ANALYZE TABLE scc10_t COMPUTE STATISTICS;

-- rpt
SELECT
pair
,AVG(g6)
,MIN(ydate)
,COUNT(ydate)
,MAX(ydate)
FROM scc10_t
GROUP BY pair
ORDER BY pair
/

DROP TABLE scc12_t;
CREATE TABLE scc12_t COMPRESS AS
SELECT
m.pair
,m.ydate
,m.prdate
,l.score-s.score score_diff
,m.g6
FROM svm62scores l,svm62scores s,scc10_t m
WHERE l.targ='gatt'
AND   s.targ='gattn'
AND l.prdate = s.prdate
AND l.prdate = m.prdate
-- Speed things up:
AND l.ydate > sysdate - 133
AND s.ydate > sysdate - 133
/

CREATE OR REPLACE VIEW scc14 AS
SELECT
pair
,ydate
,prdate
,score_diff
,g6
,COVAR_POP(score_diff,g6)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*24*1 PRECEDING AND CURRENT ROW)cpp1
,COVAR_POP(score_diff,g6)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN CURRENT ROW AND 12*24*1 FOLLOWING)cpf1
,COVAR_POP(score_diff,g6)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*24*2 PRECEDING AND CURRENT ROW)cpp2
,COVAR_POP(score_diff,g6)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN CURRENT ROW AND 12*24*2 FOLLOWING)cpf2
,COVAR_POP(score_diff,g6)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*24*3 PRECEDING AND CURRENT ROW)cpp3
,COVAR_POP(score_diff,g6)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN CURRENT ROW AND 12*24*3 FOLLOWING)cpf3
FROM scc12_t
/

DROP TABLE scc16_t;
CREATE TABLE scc16_t COMPRESS AS
SELECT
pair
,ydate
,score_diff
,g6
,cpp1
,cpp2
,cpp3
,CORR(cpp1,cpf1)OVER(PARTITION BY pair ORDER BY ydate)crr1
,CORR(cpp2,cpf2)OVER(PARTITION BY pair ORDER BY ydate)crr2
,CORR(cpp3,cpf3)OVER(PARTITION BY pair ORDER BY ydate)crr3
FROM scc14
/

ANALYZE TABLE scc16_t COMPUTE STATISTICS;

DROP TABLE scc18_t;
CREATE TABLE scc18_t COMPRESS AS
SELECT
s.pair
,s.ydate
,cpp1
,cpp2
,cpp3
,crr1
,crr2
,crr3
FROM scc16_t s
,(SELECT pair,MAX(ydate)ydate FROM scc16_t GROUP BY pair) y
WHERE s.pair= y.pair
AND s.ydate = y.ydate
/

ANALYZE TABLE scc18_t COMPUTE STATISTICS;

-- rpt
SELECT * FROM scc18_t;


CREATE OR REPLACE VIEW scc20 AS
SELECT * FROM scc18_t WHERE(cpp1>0 AND crr1>0)
UNION
SELECT * FROM scc18_t WHERE(cpp2>0 AND crr2>0)
UNION
SELECT * FROM scc18_t WHERE(cpp3>0 AND crr3>0)
UNION
SELECT * FROM scc18_t WHERE(cpp1<0 AND crr1<0)
UNION
SELECT * FROM scc18_t WHERE(cpp2<0 AND crr2<0)
UNION
SELECT * FROM scc18_t WHERE(cpp3<0 AND crr3<0)
/

-- rpt
SELECT * FROM scc20
ORDER BY cpp1
/

exit

