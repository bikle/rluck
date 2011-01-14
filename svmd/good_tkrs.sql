--
-- good_tkrs.sql
--

-- DROP TABLE good_tkrs_svmd;

CREATE TABLE good_tkrs_svmd
(
tkr VARCHAR2(9)
,crr_l NUMBER
,crr_s NUMBER
)
/

TRUNCATE TABLE good_tkrs_svmd;


CREATE OR REPLACE VIEW svmd10 AS
SELECT
tkr
,ydate
,tkr||ydate tkrdate
,LEAD(clse,1,NULL)OVER(PARTITION BY tkr ORDER BY ydate) - clse g1
FROM ystk 
WHERE ydate > '1990-01-01'
ORDER BY tkr,ydate
/

-- I join it with ystkscores:


CREATE OR REPLACE VIEW svmd12 AS
SELECT
v.tkr
,v.ydate
,v.tkrdate
,g1
,targ
,score
FROM svmd10 v, ystkscores s
WHERE v.tkrdate = s.tkrdate
ORDER BY v.tkrdate
/

INSERT INTO good_tkrs_svmd(tkr,crr_l)
SELECT tkr,crr FROM
(
SELECT
tkr
,targ
,ROUND(CORR(score,g1),2)crr
,COUNT(tkrdate)ccount
,ROUND(MIN(score),2)
,ROUND(AVG(score),2)
,ROUND(MAX(score),2)
FROM svmd12
GROUP BY tkr,targ
HAVING CORR(score,g1) > 0.1
)
WHERE targ = 'gatt'
/


INSERT INTO good_tkrs_svmd(tkr,crr_s)
SELECT tkr,crr FROM
(
SELECT
tkr
,targ
,ROUND(CORR(score,g1),2)crr
,COUNT(tkrdate)ccount
,ROUND(MIN(score),2)
,ROUND(AVG(score),2)
,ROUND(MAX(score),2)
FROM svmd12
GROUP BY tkr,targ
HAVING CORR(score,g1) < -0.1
)
WHERE targ = 'gattn'
/

SELECT * FROM good_tkrs_svmd
ORDER BY tkr,crr_l
/

CREATE OR REPLACE VIEW good_tkrs_svmd_v AS
SELECT tkr,crr_l,crr_s FROM
(
SELECT
tkr
,AVG(crr_l)crr_l
,AVG(crr_s)crr_s
FROM good_tkrs_svmd
GROUP BY tkr
HAVING COUNT(tkr)>1
)
ORDER BY crr_s - crr_l
/

SELECT * FROM good_tkrs_svmd_v;

exit

