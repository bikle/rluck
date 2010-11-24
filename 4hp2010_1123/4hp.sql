--
-- 4hp.sql
--

SET LINES 66
-- I create h15c using h15c.sql to derive prices from hourly table:
DESC h15c
SET LINES 166

CREATE OR REPLACE VIEW hp10 AS
SELECT
pair
-- ydate is granular down to the hour:
,ydate
,clse
-- Derive an attribute I call "day_hour":
,TO_CHAR(ydate,'D')||'_'||TO_CHAR(ydate,'HH24')dhr
-- Get ydate 4 hours in the future:
,LEAD(ydate,4,NULL)OVER(PARTITION BY pair ORDER BY pair,ydate) ydate4
-- Get closing price 4 hours in the future:
,LEAD(clse,4,NULL)OVER(PARTITION BY pair ORDER BY pair,ydate) clse4
-- Calculate "Normalized-Price-Gain":
,((LEAD(clse,4,NULL)OVER(PARTITION BY pair ORDER BY pair,ydate) - clse)/clse) npg
-- I use hourly to supply 6 pairs:
-- FROM hourly 
-- I use h15c to supply 15 pairs instead of just 6:
FROM h15c
WHERE ydate > sysdate - 366
-- Prevent divide by zero:
AND clse > 0
ORDER BY pair,ydate
/

-- hp10 rpt:
-- I should see 15 pairs and nearly identical counts for each pair:
SELECT pair,MIN(ydate),COUNT(*),MAX(ydate)FROM hp10 GROUP BY pair ORDER BY pair;

-- Study distribution of (ydate4 - ydate):
SELECT AVG(ydate4 - ydate), MIN(ydate4 - ydate),MAX(ydate4 - ydate),COUNT(ydate)FROM hp10;

-- I should see no rows WHERE the date difference is less than 4 hours:
SELECT COUNT(ydate)FROM hp10 WHERE (ydate4 - ydate) < 4/24;

-- I should see many rows WHERE the date difference is exactly 4 hours:
SELECT COUNT(ydate)FROM hp10 WHERE (ydate4 - ydate) = 4/24;

-- I should see some rows 
-- WHERE the date difference is greater than 4 hours due to Saturday getting sandwiched between some of the records.
-- Also if I am missing some rows, counts will appear here:
SELECT TO_CHAR(ydate,'Day'),MIN(ydate),COUNT(ydate),MAX(ydate)
FROM hp10 WHERE (ydate4 - ydate) > 4/24
GROUP BY TO_CHAR(ydate,'Day')
ORDER BY COUNT(ydate)
/

-- I create a view of what I call "Near-Past":
CREATE OR REPLACE VIEW hpnp AS SELECT * FROM hp10 WHERE ydate > sysdate - 60;

-- I create a view of what I call "Far-Past":
CREATE OR REPLACE VIEW hpfp AS SELECT * FROM hp10 WHERE ydate <= sysdate - 60;


-- Now I can aggregate Far-Past:
CREATE OR REPLACE VIEW hpfp_agg AS
SELECT
pair,dhr
,COUNT(npg)count_npg
,ROUND(MIN(npg),4)min_npg
,ROUND(AVG(npg),4)avg_npg
,ROUND(STDDEV(npg),4)stddev_npg
,ROUND(MAX(npg),4)max_npg
,ROUND(SUM(npg),4)sum_npg
FROM hpfp
WHERE (ydate4 - ydate) = 4/24
GROUP BY pair,dhr
-- I want more than 1.5 pip / hr over the 4hr period:
HAVING ABS(AVG(npg)) > 1.5 * 0.0001 * 4
/

-- hpfp_agg rpt:
SELECT COUNT(*)FROM hpfp_agg;

SELECT * FROM hpfp_agg ORDER BY pair,dhr

-- Now I can aggregate Near-Past:
CREATE OR REPLACE VIEW hpnp_agg AS
SELECT
pair,dhr
,COUNT(npg)count_npg
,ROUND(MIN(npg),4)min_npg
,ROUND(AVG(npg),4)avg_npg
,ROUND(STDDEV(npg),4)stddev_npg
,ROUND(MAX(npg),4)max_npg
,ROUND(SUM(npg),4)sum_npg
FROM hpnp
WHERE (ydate4 - ydate) = 4/24
GROUP BY pair,dhr
/

-- hpnp_agg rpt:
SELECT COUNT(*)FROM hpnp_agg;

SELECT * FROM hpnp_agg ORDER BY pair,dhr

-- Join agg views:

CREATE OR REPLACE VIEW hp4aggj AS
SELECT
a.pair
,a.dhr
,a.avg_npg avg_npg1
,b.avg_npg avg_npg2
FROM hpfp_agg a, hpnp_agg b
WHERE a.pair = b.pair AND a.dhr = b.dhr
/

-- Sort by dhr since I can then easily compare to my calendar:
SELECT * FROM hp4aggj ORDER BY dhr,pair;

-- Look for CORR() for each pair:
SELECT pair, CORR(avg_npg1,avg_npg2),COUNT(dhr)FROM hp4aggj GROUP BY pair ORDER BY pair;

-- Look CORR() for each day:
SELECT CORR(avg_npg1,avg_npg2),COUNT(dhr)FROM hp4aggj WHERE dhr LIKE'1%';
SELECT CORR(avg_npg1,avg_npg2),COUNT(dhr)FROM hp4aggj WHERE dhr LIKE'2%';
SELECT CORR(avg_npg1,avg_npg2),COUNT(dhr)FROM hp4aggj WHERE dhr LIKE'3%';
SELECT CORR(avg_npg1,avg_npg2),COUNT(dhr)FROM hp4aggj WHERE dhr LIKE'4%';
SELECT CORR(avg_npg1,avg_npg2),COUNT(dhr)FROM hp4aggj WHERE dhr LIKE'5%';
SELECT CORR(avg_npg1,avg_npg2),COUNT(dhr)FROM hp4aggj WHERE dhr LIKE'6%';

-- Look at CORR()-combo of some pairs and days:

SELECT CORR(avg_npg1,avg_npg2),COUNT(dhr)FROM hp4aggj WHERE dhr LIKE'3%'AND pair IN('gbp_usd','gbp_chf');

SELECT
CORR(avg_npg1,avg_npg2)
,COUNT(dhr)
FROM hp4aggj
WHERE dhr LIKE'4%'
AND pair IN('aud_usd','eur_aud','gbp_jpy','usd_jpy')
/

-- Look at pair IN('gbp_usd','gbp_chf') WHERE dhr LIKE'3%':
SELECT * FROM hp4aggj WHERE dhr LIKE'3%'AND pair IN('gbp_usd','gbp_chf')ORDER BY dhr,pair;

-- Look at pair IN('aud_usd','eur_aud','gbp_jpy','usd_jpy') WHERE dhr LIKE'4%':
SELECT * FROM hp4aggj WHERE dhr LIKE'4%'AND pair IN('aud_usd','eur_aud','gbp_jpy','usd_jpy')ORDER BY dhr,pair;

exit

