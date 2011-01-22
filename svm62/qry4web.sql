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
,100*six_hr_gain / price_open pct_gain
,CASE WHEN(score_long-score_short)>0.5 THEN'buy'ELSE NULL END buy
,CASE WHEN(score_short-score_long)>0.5 THEN'sell'ELSE NULL END sell
FROM w10 p, w12 s
WHERE p.prdate = s.prdate
ORDER BY p.prdate
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

COLUMN pct_gain FORMAT      999.9999
COLUMN sum_pct_gain FORMAT 9999.9999
COLUMN avg_pct_gain FORMAT  999.9999

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


CREATE OR REPLACE VIEW w16 AS
SELECT
pair
,ydate
,buy
,sell
,pct_gain
,score_long
,score_short
FROM w14
WHERE(buy='buy'OR sell='sell')
AND ABS(pct_gain)>0
/


-- Look at the last 2 weeks:
SELECT
buy
,sell
,AVG(pct_gain)   avg_pct_gain
,SUM(pct_gain)   sum_pct_gain
,COUNT(pct_gain) ccount
,CORR((score_long-score_short),pct_gain)corr_long
,CORR((score_short-score_long),pct_gain)corr_short
FROM w16
WHERE ydate > sysdate - 15
GROUP BY buy,sell
ORDER BY buy,sell
/

SELECT
pair
,buy
,sell
,AVG(pct_gain)   avg_pct_gain
,SUM(pct_gain)   sum_pct_gain
,COUNT(pct_gain) ccount
,CORR((score_long-score_short),pct_gain)corr_long
,CORR((score_short-score_long),pct_gain)corr_short
FROM w16
WHERE ydate > sysdate - 15
GROUP BY buy,sell,pair
ORDER BY buy,sell,pair
/

SELECT
TO_CHAR(ydate,'D')Dn
,TO_CHAR(ydate,'Dy')Dday
,buy
,sell
,AVG(pct_gain)   avg_pct_gain
,SUM(pct_gain)   sum_pct_gain
,COUNT(pct_gain) ccount
,CORR((score_long-score_short),pct_gain)corr_long
,CORR((score_short-score_long),pct_gain)corr_short
FROM w16
WHERE ydate > sysdate - 15
GROUP BY buy,sell,TO_CHAR(ydate,'D'),TO_CHAR(ydate,'Dy')
ORDER BY buy,sell,TO_CHAR(ydate,'D'),TO_CHAR(ydate,'Dy')
/

-- Look at the last week:

SELECT
buy
,sell
,AVG(pct_gain)   avg_pct_gain
,SUM(pct_gain)   sum_pct_gain
,COUNT(pct_gain) ccount
,CORR((score_long-score_short),pct_gain)corr_long
,CORR((score_short-score_long),pct_gain)corr_short
FROM w16
WHERE ydate > sysdate - 8
GROUP BY buy,sell
ORDER BY buy,sell
/

SELECT
pair
,buy
,sell
,AVG(pct_gain)   avg_pct_gain
,SUM(pct_gain)   sum_pct_gain
,COUNT(pct_gain) ccount
,CORR((score_long-score_short),pct_gain)corr_long
,CORR((score_short-score_long),pct_gain)corr_short
FROM w16
WHERE ydate > sysdate - 8
GROUP BY buy,sell,pair
ORDER BY buy,sell,pair
/

SELECT
TO_CHAR(ydate,'D')Dn
,TO_CHAR(ydate,'Dy')Dday
,buy
,sell
,AVG(pct_gain)   avg_pct_gain
,SUM(pct_gain)   sum_pct_gain
,COUNT(pct_gain) ccount
,CORR((score_long-score_short),pct_gain)corr_long
,CORR((score_short-score_long),pct_gain)corr_short
FROM w16
WHERE ydate > sysdate - 8
GROUP BY buy,sell,TO_CHAR(ydate,'D'),TO_CHAR(ydate,'Dy')
ORDER BY buy,sell,TO_CHAR(ydate,'D'),TO_CHAR(ydate,'Dy')
/

SELECT
pair
,buy
,sell
,AVG(pct_gain)   avg_pct_gain
,SUM(pct_gain)   sum_pct_gain
,COUNT(pct_gain) ccount
,CORR((score_long-score_short),pct_gain)corr_long
,CORR((score_short-score_long),pct_gain)corr_short
FROM w16
WHERE ydate > sysdate - 167/24
GROUP BY buy,sell,pair
ORDER BY buy,sell,pair
/

SELECT
buy
,sell
,AVG(pct_gain)   avg_pct_gain
,SUM(pct_gain)   sum_pct_gain
,COUNT(pct_gain) ccount
,CORR((score_long-score_short),pct_gain)corr_long
,CORR((score_short-score_long),pct_gain)corr_short
FROM w16
WHERE ydate > sysdate - 167/24
GROUP BY buy,sell
ORDER BY buy,sell
/

SELECT
buy
,sell
,AVG(pct_gain)   avg_pct_gain
,SUM(pct_gain)   sum_pct_gain
,COUNT(pct_gain) ccount
,CORR((score_long-score_short),pct_gain)corr_long
,CORR((score_short-score_long),pct_gain)corr_short
FROM w16
WHERE ydate > sysdate - 87/24
GROUP BY buy,sell
ORDER BY buy,sell
/

SELECT
buy
,sell
,AVG(pct_gain)   avg_pct_gain
,SUM(pct_gain)   sum_pct_gain
,COUNT(pct_gain) ccount
,CORR((score_long-score_short),pct_gain)corr_long
,CORR((score_short-score_long),pct_gain)corr_short
FROM w16
WHERE ydate > sysdate - 47/24
GROUP BY buy,sell
ORDER BY buy,sell
/

SELECT
buy
,sell
,AVG(pct_gain)   avg_pct_gain
,SUM(pct_gain)   sum_pct_gain
,COUNT(pct_gain) ccount
,CORR((score_long-score_short),pct_gain)corr_long
,CORR((score_short-score_long),pct_gain)corr_short
FROM w16
WHERE ydate > sysdate - 27/24
GROUP BY buy,sell
ORDER BY buy,sell
/

SELECT
buy
,sell
,AVG(pct_gain)   avg_pct_gain
,SUM(pct_gain)   sum_pct_gain
,COUNT(pct_gain) ccount
,CORR((score_long-score_short),pct_gain)corr_long
,CORR((score_short-score_long),pct_gain)corr_short
FROM w16
WHERE ydate > sysdate - 17/24
GROUP BY buy,sell
ORDER BY buy,sell
/

exit
