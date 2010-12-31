--
-- avg_recent_scores.sql
--

-- I use this script to look at an avg of recent scores.

-- I create ocj in ../openclose/oc.sql
-- And here:
-- done already
CREATE OR REPLACE VIEW ocj AS
SELECT
s.prdate
,s.score
,s.rundate
,s.pair
,s.ydate
,g.score gscore
,p.clse
FROM fxscores6 s
,fxscores6_gattn g
,di5min p
WHERE s.prdate = g.prdate
AND REPLACE(REPLACE(p.pair,'usd_',''),'_usd','') = s.pair
AND s.ydate = p.ydate
/

-- done already

-- 1st I show the actual scores:
@qry_recent_fxscores.sql

-- Look for good longs:
CREATE OR REPLACE VIEW good_longs AS
SELECT
pair
,AVG(score) long_score
,AVG(gscore)short_score
,MIN(ydate) mndate
,COUNT(pair)cnt
,MAX(ydate) mxdate
,ROUND(MIN(clse),4)mn_clse
,ROUND(AVG(clse),4)avg_clse
,ROUND(MAX(clse),4)mx_clse
FROM ocj
WHERE ydate > sysdate - 2/24
GROUP BY pair
HAVING(AVG(score) > 0.6 AND AVG(gscore) < 0.4)
ORDER BY MAX(rundate)
/

-- Look for good shorts:
CREATE OR REPLACE VIEW good_shorts AS
SELECT
pair
,AVG(score) long_score
,AVG(gscore)short_score
,MIN(ydate) mndate
,COUNT(pair)cnt
,MAX(ydate) mxdate
,ROUND(MIN(clse),4)mn_clse
,ROUND(AVG(clse),4)avg_clse
,ROUND(MAX(clse),4)mx_clse
FROM ocj
WHERE ydate > sysdate - 2/24
GROUP BY pair
HAVING(AVG(gscore) > 0.6 AND AVG(score) < 0.4)
ORDER BY MAX(rundate)
/

SELECT * FROM good_longs;

SELECT * FROM good_shorts;

-- Now join with recent prices:

CREATE OR REPLACE VIEW glp AS
SELECT
g.pair
,g.long_score
,g.short_score
,g.mndate
,g.cnt
,g.mxdate
,g.mn_clse
,g.avg_clse
,g.mx_clse
,avg_r_clse
FROM good_longs g
,(SELECT pair,AVG(clse)avg_r_clse FROM ocj WHERE ydate>sysdate-1/24 GROUP BY pair) p
WHERE g.pair = p.pair
/

CREATE OR REPLACE VIEW gsp AS
SELECT
g.pair
,g.long_score
,g.short_score
,g.mndate
,g.cnt
,g.mxdate
,g.mn_clse
,g.avg_clse
,g.mx_clse
,avg_r_clse
FROM good_shorts g
,(SELECT pair,AVG(clse)avg_r_clse FROM ocj WHERE ydate>sysdate-1/24 GROUP BY pair) p
WHERE g.pair = p.pair
/

SELECT * FROM glp;

SELECT * FROM gsp;

exit

