--
-- qry4web.sql
--

-- I use this script to gather data for exposure to the web.

-- Get prices and gains first.

COLUMN price FORMAT 999.9999

CREATE OR REPLACE VIEW w10 AS
SELECT
prdate
,pair
,ydate
,ROUND(clse,4)price_open
,ROUND(LEAD(clse,12*6,NULL)OVER(PARTITION BY pair ORDER BY ydate),4)price_close
,ROUND(LEAD(clse,12*6,NULL)OVER(PARTITION BY pair ORDER BY ydate)-clse,4)six_hr_gain
,LEAD(ydate,12*6,NULL)OVER(PARTITION BY pair ORDER BY ydate) ydate6
FROM di5min
ORDER BY pair,ydate
/

-- I should see recent data:

SELECT pair,COUNT(pair)FROM w10 WHERE ydate > sysdate - 0.5/24 GROUP BY pair;

SELECT pair,COUNT(pair)FROM w10 WHERE ydate > sysdate - 7/24 AND ydate6 IS NOT NULL GROUP BY pair;

-- Now get scores:

CREATE OR REPLACE VIEW w12 AS
SELECT
l.prdate
,l.score score_long
,s.score score_short
,l.pair
,l.ydate
FROM svm62scores l
,svm62scores s
WHERE l.prdate = s.prdate
AND l.targ = 'gatt'
AND s.targ = 'gattn'
ORDER BY l.prdate
/

-- I should see recent scores:

SELECT pair,COUNT(pair)FROM w12 WHERE ydate > sysdate - 0.5/24 GROUP BY pair;

-- Join em:
CREATE OR REPLACE VIEW w14 AS
SELECT
p.pair
,p.ydate
,ydate6
,price_open
,price_close
,six_hr_gain
,score_long
,score_short
-- Next page:
,24*(ydate6 - p.ydate)hold_duration
,ROUND(100*six_hr_gain / price_open,4) pct_gain
,CASE WHEN(score_long-score_short)>0.6 THEN'buy'ELSE NULL END buy
,CASE WHEN(score_short-score_long)>0.6 THEN'sell'ELSE NULL END sell
FROM w10 p, w12 s
WHERE p.prdate = s.prdate
ORDER BY p.prdate
/

SELECT
pair
,buy
,sell
,SUM(pct_gain)   sum_pct_gain
,COUNT(pct_gain) ccount
,CORR((score_long-score_short),pct_gain)corr_long
,CORR((score_short-score_long),pct_gain)corr_short
FROM w14
WHERE ydate > sysdate - 7/24 
AND ydate6 IS NOT NULL
GROUP BY pair,buy,sell
ORDER BY pair,buy,sell
/

SELECT
pair
,ydate
,ydate6
,price_open
,price_close
,six_hr_gain
,score_long
,score_short
FROM w14
WHERE ydate > sysdate - 7/24
AND ydate6 IS NOT NULL

COLUMN pct_gain FORMAT 999.9999

SELECT
pair
,ydate
,hold_duration
,pct_gain
,buy
,sell
FROM w14
WHERE ydate > sysdate - 7/24
AND ydate6 IS NOT NULL

SELECT
pair
,SUM(pct_gain)
FROM w14
WHERE ydate > sysdate - 7/24
AND ydate6 IS NOT NULL
AND (score_long-score_short)>0.6
GROUP BY pair
ORDER BY pair

SELECT
pair
,SUM(pct_gain)
FROM w14
WHERE ydate > sysdate - 7/24
AND ydate6 IS NOT NULL
AND (score_short-score_long)>0.6
GROUP BY pair
ORDER BY pair

exit
