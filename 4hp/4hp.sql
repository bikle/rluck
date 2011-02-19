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
SELECT COUNT(ydate)FROM hp12;

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
,TRUNC(ydate)trunc_date
FROM hp12
ORDER BY pair,dhr,ydate
/

-- I aggregate now.
CREATE OR REPLACE VIEW hp16 AS
SELECT
pair
,dhr
,trunc_date
,dyhr
,AVG(npg)            avg_npg1
,STDDEV(npg)         std_npg1
,AVG(npg)/STDDEV(npg)sratio1
FROM hp14
GROUP BY 
pair
,dhr
,trunc_date
,dyhr
-- Prevent divide by 0:
HAVING STDDEV(npg) > 0.0001
ORDER BY 
pair
,dhr
,trunc_date
,dyhr
/

-- rpt

SELECT
pair
,dhr
,trunc_date
,dyhr
,avg_npg1
,std_npg1
,sratio1
FROM hp16
WHERE pair='usd_jpy'AND dhr='5_16'
/

-- Add columns for date 1 week in future.
-- Other columns too.
CREATE OR REPLACE VIEW hp18 AS
SELECT
pair
,dhr
,dyhr
,trunc_date
,avg_npg1
,std_npg1
,sratio1
,LEAD(trunc_date,1,NULL)OVER(PARTITION BY pair,dhr ORDER BY trunc_date)ld_tdate
,LEAD(avg_npg1,1,NULL)OVER(PARTITION BY pair,dhr ORDER BY trunc_date)ld_avg_npg1
,LEAD(std_npg1,1,NULL)OVER(PARTITION BY pair,dhr ORDER BY trunc_date)ld_std_npg1
,LEAD(sratio1,1,NULL)OVER(PARTITION BY pair,dhr ORDER BY trunc_date)ld_sratio1
,COUNT(dhr)OVER(PARTITION BY pair,dhr ORDER BY trunc_date  ROWS BETWEEN 3 PRECEDING AND CURRENT ROW)count4
,AVG(sratio1)OVER(PARTITION BY pair,dhr ORDER BY trunc_date ROWS BETWEEN 3 PRECEDING AND CURRENT ROW)avg_sratio1
FROM hp16
ORDER BY 
pair
,dhr
,trunc_date
,dyhr
/

-- rpt

SELECT
pair
-- ,dhr
-- ,dyhr
,trunc_date
,ld_tdate
,sratio1
,ld_sratio1
-- ,avg_npg1
-- ,ld_avg_npg1
-- ,std_npg1
-- ,ld_std_npg1
,count4
,avg_sratio1
FROM hp18
WHERE pair='usd_jpy'AND dhr='5_16'
/

-- Refine it.
CREATE OR REPLACE VIEW hp20 AS
SELECT
pair
,dhr
,dyhr
,trunc_date
,avg_npg1
,std_npg1
,sratio1
,ld_tdate
,ld_avg_npg1
,ld_std_npg1
,ld_sratio1
,count4
,avg_sratio1
FROM hp18
WHERE count4 = 4
AND ABS(avg_sratio1) > 1.0
ORDER BY 
pair
,dhr
,trunc_date
/

-- rpt
SELECT
pair
,dhr
,trunc_date
,sratio1
,ld_tdate
,ld_sratio1
,count4
,avg_sratio1
FROM hp20
WHERE pair='usd_jpy'AND dhr='5_16'
/

SELECT
CORR(sratio1,ld_sratio1)
,AVG(sratio1)
,AVG(ld_sratio1)
FROM hp20
WHERE pair='usd_jpy'AND dhr='5_16'
/

SELECT
pair
,SIGN(sratio1)
,CORR(sratio1,ld_sratio1)
,AVG(sratio1)
,AVG(ld_sratio1)
,COUNT(pair)
FROM hp20
WHERE pair='usd_jpy'AND dhr='5_16'
GROUP BY pair,SIGN(sratio1)
ORDER BY pair,SIGN(sratio1)
/

SELECT
pair
,SIGN(sratio1)
,CORR(sratio1,ld_sratio1)
,AVG(sratio1)
,AVG(ld_sratio1)
,COUNT(pair)
FROM hp20
GROUP BY pair,SIGN(sratio1)
ORDER BY pair,SIGN(sratio1)
/

exit
