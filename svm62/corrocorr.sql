--
-- corrocorr.sql
--

-- I use this script to study past and future score-gain corr.

-- I start by getting the 6 hr gain for each prdate.
CREATE OR REPLACE VIEW coc10 AS
SELECT
prdate
,pair
,ydate
,(LEAD(clse,12*6,NULL)OVER(PARTITION BY pair ORDER BY ydate)-clse)/clse g6
FROM di5min
-- WHERE ydate BETWEEN(sysdate - 34)AND'2011-01-14'
WHERE ydate > sysdate - 122
AND clse > 0
ORDER BY pair,ydate
/

-- rpt
SELECT
pair
,AVG(g6)
,MIN(ydate)
,COUNT(ydate)
,MAX(ydate)
FROM coc10
GROUP BY pair
ORDER BY pair
/

CREATE OR REPLACE VIEW coc12 AS
SELECT
m.pair
,m.ydate
,m.prdate
,l.score score_long
,s.score score_short
,l.score-s.score score_diff
,ROUND(l.score,1) rscore_long
,ROUND(s.score,1) rscore_short
,ROUND((l.score-s.score),1) rscore_diff
,m.g6
FROM svm62scores l,svm62scores s,coc10 m
WHERE l.targ='gatt'
AND   s.targ='gattn'
AND l.prdate = s.prdate
AND l.prdate = m.prdate
-- Speed things up:
AND l.ydate > sysdate - 133
AND s.ydate > sysdate - 133
/


CREATE OR REPLACE VIEW coc14 AS
SELECT
pair
,ydate
,prdate
,score_long
,score_short
,score_diff
,rscore_long
,rscore_short
,rscore_diff
,g6
,COVAR_POP(score_diff,g6)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*24*1 PRECEDING AND CURRENT ROW)cpp1
,COVAR_POP(score_diff,g6)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN CURRENT ROW AND 12*24*1 FOLLOWING)cpf1
,COVAR_POP(score_diff,g6)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*24*2 PRECEDING AND CURRENT ROW)cpp2
,COVAR_POP(score_diff,g6)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN CURRENT ROW AND 12*24*2 FOLLOWING)cpf2
,COVAR_POP(score_diff,g6)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 12*24*3 PRECEDING AND CURRENT ROW)cpp3
,COVAR_POP(score_diff,g6)OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN CURRENT ROW AND 12*24*3 FOLLOWING)cpf3
FROM coc12
/

-- rpt
SELECT
pair
,COUNT(pair)    ccount
,CORR(cpp1,cpf1)crr1
,CORR(cpp2,cpf2)crr2
,CORR(cpp3,cpf3)crr3
FROM coc14 GROUP BY pair ORDER BY pair
/

-- exit
