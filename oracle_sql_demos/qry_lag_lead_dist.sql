--
-- qry_lag_lead_dist.sql
--

-- Helps me see the distribution of lags and resulting leads in stkib

-- rpt
set lines 66
desc stkib2
set lines 123

CREATE OR REPLACE VIEW lld10 AS
SELECT
tkr
,ydate
,yprice
-LAG(yprice,2,NULL)OVER(PARTITION BY tkr ORDER BY ydate) d02
,LEAD(yprice,1,NULL)OVER(PARTITION BY tkr ORDER BY ydate)
-yprice ug
FROM stkib2
/

CREATE OR REPLACE VIEW lld12 AS
SELECT
tkr
,d02
,STDDEV(d02)OVER(PARTITION BY tkr)a_sd2
,ug
FROM lld10
ORDER by d02
/

-- qry
SELECT
tkr
,STDDEV(d02)sd2
FROM lld12
GROUP BY tkr
ORDER BY STDDEV(d02),tkr
/
-- rpt
SELECT COUNT(tkr)FROM lld12 WHERE tkr='POT';
SELECT MIN(a_sd2),AVG(a_sd2),MAX(a_sd2)FROM lld12 WHERE tkr='POT';


CREATE OR REPLACE VIEW lld14 AS
SELECT
tkr
,d02
,a_sd2
,ug
FROM lld12
WHERE ABS(d02) > a_sd2
ORDER by d02
/

-- rpt
SELECT COUNT(tkr)FROM lld14;
SELECT CORR(d02,ug)FROM lld14;

SELECT 
SUM(d02),SUM(ug)
FROM lld14
WHERE d02<0
/

SELECT 
SUM(d02),SUM(ug)
FROM lld14
WHERE d02>0
/

exit
