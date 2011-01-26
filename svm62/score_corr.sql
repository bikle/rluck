--
-- score_corr.sql
--

-- I use this script to help me see recent CORR() between score and gain.

-- I start by getting the 6 hr gain for each prdate.
CREATE OR REPLACE VIEW sc10 AS
SELECT
prdate
,pair
,ydate
,LEAD(clse,12*6,NULL)OVER(PARTITION BY pair ORDER BY ydate)-clse g6
FROM di5min
-- Speed things up:
WHERE ydate > sysdate - 95
ORDER BY pair,ydate
/

-- rpt
SELECT pair,AVG(g6)FROM sc10 GROUP BY pair;

CREATE OR REPLACE VIEW sc12 AS
SELECT
m.pair
,m.ydate
,m.prdate
,l.score score_long
,s.score score_short
,m.g6
FROM svm62scores l,svm62scores s,sc10 m
WHERE l.targ='gatt'
AND   s.targ='gattn'
AND l.prdate = s.prdate
AND l.prdate = m.prdate
-- Speed things up:
AND l.ydate > sysdate -95
AND s.ydate > sysdate -95
/

DROP TABLE score_corr;

PURGE RECYCLEBIN;

CREATE TABLE score_corr COMPRESS AS
SELECT
pair
,ydate
,prdate
-- Find corr() tween score and g6 over 2 day period:
,CORR((score_long - score_short),g6)
  OVER(PARTITION BY pair ORDER BY ydate ROWS BETWEEN 2*24*60/5 PRECEDING AND CURRENT ROW)sc_corr
FROM sc12
/

-- rpt
SELECT pair,AVG(sc_corr),COUNT(pair)
FROM score_corr 
WHERE ydate > sysdate - 1/24
GROUP BY pair ORDER BY pair
/

-- I should see something similar but probly not exactly the same:

SELECT
pair
,CORR((score_long - score_short),g6)score_corr
FROM sc12
WHERE ydate > sysdate -2
GROUP BY pair ORDER BY pair
/

exit

