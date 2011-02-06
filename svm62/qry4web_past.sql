--
-- qry4web_past.sql
--

-- I use this script to gather past data for exposure to the web.

-- Get prices and gains first.

CREATE OR REPLACE VIEW w10 AS
SELECT
prdate
,pair
,ydate
,ROUND(clse,4)price_open
,ROUND(LEAD(clse,12*6,NULL)OVER(PARTITION BY pair ORDER BY ydate),4)price_close
,ROUND(LEAD(clse,12*6,NULL)OVER(PARTITION BY pair ORDER BY ydate)-clse,4)six_hr_gain
,LEAD(clse,12*6,NULL)OVER(PARTITION BY pair ORDER BY ydate)-clse      six_hr_gain_nr
,LEAD(ydate,12*6,NULL)OVER(PARTITION BY pair ORDER BY ydate) ydate6
FROM di5min
ORDER BY pair,ydate
/

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

-- rpt

SELECT pair,COUNT(pair)FROM w12 WHERE ydate > sysdate - 7 GROUP BY pair

SELECT
TO_CHAR(ydate,'D')daynum,TO_CHAR(ydate,'Dy')day_name
,COUNT(ydate)
FROM w12
WHERE ydate > sysdate - 7
GROUP BY TO_CHAR(ydate,'D'),TO_CHAR(ydate,'Dy')
ORDER BY TO_CHAR(ydate,'D')

-- Join em:
CREATE OR REPLACE VIEW w14 AS
SELECT
p.pair
,p.ydate
,ydate6
,price_open
,price_close
,six_hr_gain
,six_hr_gain_nr
,score_long
,score_short
,score_long-score_short          score
-- Next page:
,24*(ydate6 - p.ydate)           hold_duration
,six_hr_gain_nr / price_open     pct_gain
,100*six_hr_gain_nr / price_open pct_gainx100
,CASE WHEN(score_long-score_short)>0.6 THEN'buy'
      WHEN(score_long-score_short)<-0.6 THEN'sell  '
      ELSE 'avoid ' END action
FROM w10 p, w12 s
WHERE p.prdate = s.prdate
ORDER BY p.prdate
/

-- rpt on recent data:

COLUMN action FORMAT A6
COLUMN price_open  FORMAT 999.9999
COLUMN price_close FORMAT 999.9999
COLUMN six_hr_gain FORMAT  99.9999
COLUMN score       FORMAT   9.99
COLUMN hold_duration FORMAT  99.99
COLUMN pct_gain     FORMAT  999.9999
COLUMN pct_gainx100 FORMAT  999.9999
COLUMN sum_pct_gain FORMAT 9999.9999
COLUMN avg_pct_gain FORMAT  999.9999
COLUMN avg_pct_gainx100 FORMAT  999.9999
COLUMN sharpe_r     FORMAT  999.9999

SELECT
ROUND(score,2) score
,action
,pair
,ydate  date_open
,price_open
,TO_CHAR(ydate6,'MM-DD HH24:MI') date_close
,ROUND(pct_gainx100,2) pct_gainx100
,price_close
,six_hr_gain
,CASE WHEN(action='buy'AND pct_gain>0.0)THEN 'good'
      WHEN(action='sell  'AND pct_gain<0.0)THEN 'good'
      WHEN(action='buy'AND pct_gain<0.0)THEN 'bad'
      WHEN(action='sell  'AND pct_gain>0.0)THEN 'bad'
      ELSE NULL END goodbad
FROM w14
-- WHERE ydate > sysdate - 1/2
WHERE ydate > (SELECT MAX(ydate)-8/24 FROM w14)


-- Aggregate above query results.

-- Show 8 hr before max(ydate):

SELECT
action
,SUM(pct_gain)                  sum_pct_gain
,COUNT(pct_gain)                ccount
,AVG(pct_gain)/STDDEV(pct_gain) sharpe_r
FROM w14
WHERE ydate > (SELECT MAX(ydate)-8/24 FROM w14)
GROUP BY action
ORDER BY action
/

-- Show 30 hr before max(ydate):

SELECT
action
,SUM(pct_gain)                          sum_pct_gain
,COUNT(pct_gain)                        ccount
,ROUND(AVG(pct_gain)/STDDEV(pct_gain),2)sharpe_r
FROM w14
WHERE ydate>(SELECT MAX(ydate)-30/24 FROM w14)
GROUP BY action
ORDER BY action
/

-- rpt on prediction aggregations

CREATE OR REPLACE VIEW w16 AS
SELECT
pair
,ydate
,action
,pct_gain
,pct_gainx100
,score
,ROUND(score,1)          rscore
,TO_CHAR(ydate,'YYYY_MM')mnth
,TO_CHAR(ydate,'W')      wk_num
FROM w14
WHERE ABS(pct_gainx100)>0
/

-- Aggregate by pair

SELECT
pair
,COUNT(pct_gain)               ccount
,action
,ROUND(AVG(pct_gainx100),2)    avg_pct_gainx100
,ROUND(SUM(pct_gain),2)        sum_pct_gain
,ROUND(AVG(score),2)           avg_score
,ROUND(CORR(score,pct_gain),2) score_corr
,ROUND(AVG(pct_gain)/STDDEV(pct_gain),2)sharpe_r
FROM w16
GROUP BY action,pair
ORDER BY action,pair
/

-- Aggregate by day:

SELECT
TO_CHAR(ydate,'D')Dn
,TO_CHAR(ydate,'Dy')Dday
,COUNT(pct_gain)              ccount
,action
,ROUND(AVG(pct_gainx100),2)   avg_pct_gainx100
,ROUND(SUM(pct_gain),2)       sum_pct_gain
,ROUND(AVG(score),2)          avg_score
,ROUND(CORR(score,pct_gain),2)score_corr
,ROUND(AVG(pct_gain)/STDDEV(pct_gain),2)sharpe_r
FROM w16
GROUP BY action,TO_CHAR(ydate,'D'),TO_CHAR(ydate,'Dy')
ORDER BY action,TO_CHAR(ydate,'D'),TO_CHAR(ydate,'Dy')
/

-- Aggregate by month:

SELECT
mnth
,COUNT(pct_gain)              ccount
,action
,ROUND(AVG(pct_gainx100),2)   avg_pct_gainx100
,ROUND(SUM(pct_gain),2)       sum_pct_gain
,ROUND(AVG(score),2)          avg_score
,ROUND(CORR(score,pct_gain),2)score_corr
,ROUND(AVG(pct_gain)/STDDEV(pct_gain),2)sharpe_r
FROM w16
GROUP BY action,mnth
ORDER BY action,mnth
/

-- Aggregate by week:

SELECT
mnth
,wk_num
,COUNT(pct_gain)              ccount
,action
,ROUND(AVG(pct_gainx100),2)   avg_pct_gainx100
,ROUND(SUM(pct_gain),2)       sum_pct_gain
,ROUND(AVG(score),2)          avg_score
,ROUND(CORR(score,pct_gain),2)score_corr
,ROUND(AVG(pct_gain)/STDDEV(pct_gain),2)sharpe_r
FROM w16
GROUP BY action,mnth,wk_num
HAVING COUNT(pct_gain) > 22
ORDER BY action,mnth,wk_num
/


exit
