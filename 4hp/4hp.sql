--
-- 4hp.sql
--

SET LINES 66
DESC di5min
SET LINES 166

CREATE OR REPLACE VIEW hp10 AS
SELECT
pair
-- ydate is granular down to 5 minutes:
,ydate
,clse
-- Derive an attribute I call "day_hour":
,TO_CHAR(ydate,'D')||'_'||TO_CHAR(ROUND(ydate,'HH24'),'HH24')dhr
,TO_CHAR(ydate,'Dy')||'_'||TO_CHAR(ROUND(ydate,'HH24'),'HH24')dyhr
-- Get ydate 4 hours in the future:
,LEAD(ydate,4*12,NULL)OVER(PARTITION BY pair ORDER BY pair,ydate) ydate4
-- Get closing price 4 hours in the future:
,LEAD(clse,4*12,NULL)OVER(PARTITION BY pair ORDER BY pair,ydate) clse4
FROM di5min
WHERE ydate > '2009-01-01'
ORDER BY pair,ydate
/

-- rpt
SELECT
pair,dhr,dyhr
,MIN(ydate)min_date
,COUNT(ydate)count_npg
,MAX(ydate)max_date
FROM hp10
WHERE (ydate4 - ydate)BETWEEN 4/24 AND 4.29/24
AND dhr='3_11'
GROUP BY pair,dhr,dyhr
ORDER BY pair,dhr,dyhr
/

-- I derive more attributes:
CREATE OR REPLACE VIEW hp12 AS
SELECT
pair
,ydate
,clse
,dhr
,dyhr
,ydate4
,clse4
,(clse4 - clse)/clse npg
FROM hp10
WHERE (ydate4 - ydate)BETWEEN 4/24 AND 4.29/24
ORDER BY pair,ydate
/

--rpt
SELECT COUNT(ydate)FROM hp10;

-- Now I can aggregate:
SELECT
pair,dhr,dyhr
,MIN(ydate)min_date
,COUNT(npg)count_npg
,MAX(ydate)max_date
-- ,ROUND(MIN(npg),4)min_npg
,ROUND(AVG(npg),4)avg_npg
,ROUND(STDDEV(npg),4)stddev_npg
,ROUND(AVG(npg)/STDDEV(npg),2)sharpe_ratio
-- ,ROUND(MAX(npg),4)max_npg
-- ,ROUND(SUM(npg),4)sum_npg
FROM hp12
GROUP BY pair,dhr,dyhr
-- I want a Sharpe Ratio > 0.5
HAVING ABS(AVG(npg)/STDDEV(npg)) > 0.5
ORDER BY pair,dhr,dyhr
/

-- I derive more attributes:
CREATE OR REPLACE VIEW hp14 AS
SELECT
pair
,ydate
,clse
,dhr
,dyhr
,ydate4
,clse4
,npg
,AVG(npg)OVER(PARTITION BY pair,dhr ORDER BY ydate)avg_npg
,STDDEV(npg)OVER(PARTITION BY pair,dhr ORDER BY ydate)std_npg
FROM hp12
ORDER BY pair,dhr,ydate
/

-- rpt

select count(*)from
(
SELECT
pair,dhr,dyhr
,avg_npg
,std_npg
,avg_npg/std_npg aos
FROM hp14
WHERE pair = 'usd_jpy'
AND dhr = '5_16'
AND ABS(avg_npg/std_npg) > 0.5
AND std_npg > 0
)
/


exit
