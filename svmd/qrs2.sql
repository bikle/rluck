--
-- qrs2.sql
--

-- I use this script to query recent scores and then pick positions to open.

-- I start by getting the 1 day gain for each tkrdate.
CREATE OR REPLACE VIEW scc10svmd AS
SELECT
tkrdate
,tkr
,ydate
,clse
,LEAD(clse,1,NULL)OVER(PARTITION BY tkr ORDER BY ydate)-clse g1
FROM ystk
WHERE ydate > sysdate - 800
ORDER BY tkr,ydate
/

-- Now join with scores:

CREATE OR REPLACE VIEW scc12svmd AS
SELECT
m.tkrdate
,m.tkr
,m.ydate
,m.clse
,l.score score_long
,s.score score_short
,l.score - s.score score_diff
,l.rundate
,ROUND((l.score-s.score),2)rscore_diff
,m.g1
,CASE WHEN TO_CHAR(m.ydate,'dy')='fri'THEN m.ydate + 3
      WHEN TO_CHAR(m.ydate,'dy')IN
        ('mon','tue','wed','thu')   THEN m.ydate + 1
      ELSE NULL END clse_date
FROM ystkscores l,ystkscores s,scc10svmd m
WHERE l.targ='gatt'
AND   s.targ='gattn'
AND l.tkrdate = s.tkrdate
AND l.tkrdate = m.tkrdate
-- Speed things up:
AND l.ydate > sysdate - 800
AND s.ydate > sysdate - 800
/

-- Mix-in score-correlation:
DROP TABLE qrs2svmd;
PURGE RECYCLEBIN;

CREATE TABLE qrs2svmd COMPRESS AS
SELECT
tkrdate
,tkr
,ydate
,clse
,score_diff
,rscore_diff
,clse_date
,g1
,SIGN(score_diff)         signsd
,TO_CHAR(ydate,'YYYY_MM') mnth
,CORR(score_diff,g1)OVER(PARTITION BY tkr ORDER BY ydate ROWS BETWEEN 66 PRECEDING AND CURRENT ROW)sc_corr
FROM scc12svmd
ORDER BY tkr,ydate
/

-- backtest rpt:

COLUMN avg_g1day    FORMAT 999.99
COLUMN stddev_g1day FORMAT 999.99
COLUMN sharpe_ratio FORMAT 99.99
COLUMN sum_g1day    FORMAT 9999.99

SELECT
signsd
,mnth
,AVG(g1)   avg_g1day
,SUM(g1)   sum_g1day
,COUNT(g1) position_count
,AVG(g1)/STDDEV(g1)sharpe_ratio
FROM qrs2svmd
WHERE ABS(score_diff) > 0.6
AND sc_corr > 0.1
AND ydate > '2010-01-01'
GROUP BY signsd,mnth
HAVING STDDEV(g1) > 0
ORDER BY signsd,mnth
/

SELECT
signsd
,mnth
,AVG(g1)   avg_g1day
,SUM(g1)   sum_g1day
,COUNT(g1) position_count
,AVG(g1)/STDDEV(g1)sharpe_ratio
FROM qrs2svmd
WHERE ABS(score_diff) > 0.5
AND sc_corr > 0.1
AND ydate > '2010-01-01'
GROUP BY signsd,mnth
HAVING STDDEV(g1) > 0
ORDER BY signsd,mnth
/

-- Group by tkr instead of month:

SELECT
signsd
,tkr
,AVG(g1)   avg_g1day
,SUM(g1)   sum_g1day
,COUNT(g1) position_count
,AVG(g1)/STDDEV(g1)sharpe_ratio
FROM qrs2svmd
WHERE ABS(score_diff) > 0.5
AND sc_corr > 0.1
AND ydate > '2010-01-01'
GROUP BY signsd,tkr
HAVING STDDEV(g1)>0 AND COUNT(g1)>9
ORDER BY signsd,tkr
/

-- Order by count so I can see active tkrs

SELECT
signsd
,tkr
,AVG(g1)   avg_g1day
,SUM(g1)   sum_g1day
,COUNT(g1) position_count
,AVG(g1)/STDDEV(g1)sharpe_ratio
FROM qrs2svmd
WHERE ABS(score_diff) > 0.5
AND sc_corr > 0.1
AND ydate > '2010-01-01'
GROUP BY signsd,tkr
HAVING STDDEV(g1)>0 AND COUNT(g1)>9
ORDER BY signsd,COUNT(g1)
/


-- Order by tkr so I can see balanced tkrs:

SELECT
signsd
,tkr
,AVG(g1)   avg_g1day
,SUM(g1)   sum_g1day
,COUNT(g1) position_count
,AVG(g1)/STDDEV(g1)sharpe_ratio
FROM qrs2svmd
WHERE ABS(score_diff) > 0.5
AND sc_corr > 0.1
AND ydate > '2010-01-01'
GROUP BY signsd,tkr
HAVING STDDEV(g1)>0 AND COUNT(g1)>9
ORDER BY tkr,signsd
/

-- Info for future positions:

SELECT
signsd
,ydate
,tkr
,clse
,rscore_diff
,g1
,clse_date
FROM qrs2svmd
WHERE ABS(score_diff) > 0.5
AND sc_corr > 0.1
AND ydate > '2011-03-28'
ORDER BY signsd,ydate,tkr
/

exit
