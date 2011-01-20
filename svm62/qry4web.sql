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

SELECT * FROM w10 WHERE ydate > sysdate - 0.5/24;

SELECT COUNT(*) FROM w10 WHERE ydate > sysdate - 7/24 AND ydate6 IS NOT NULL;


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

SELECT * FROM w12 WHERE ydate > sysdate - 0.5/24;


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
FROM w10 p, w12 s
WHERE p.prdate = s.prdate
ORDER BY p.prdate
/

SELECT COUNT(*)FROM w14
WHERE ydate > sysdate - 7/24 AND ydate6 IS NOT NULL
/

SELECT * FROM w14
WHERE ydate > sysdate - 7/24 AND ydate6 IS NOT NULL
/

exit
