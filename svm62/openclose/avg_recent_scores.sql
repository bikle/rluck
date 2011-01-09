--
-- avg_recent_scores.sql
--

-- I use this script to look at an avg of recent scores.

-- I create ocj in ../openclose/oc.sql
-- And here:
-- done already
CREATE OR REPLACE VIEW ocj AS
SELECT
l.prdate
,l.score score_long
,s.score score_short
,l.rundate
,l.pair
,l.ydate
,p.clse
FROM svm62scores l
,svm62scores s
,di5min p
WHERE l.prdate = s.prdate
AND p.pair = l.pair
AND l.ydate = p.ydate
AND l.targ = 'gatt'
AND s.targ = 'gattn'
/

-- done already

-- 1st I show the actual scores:
-- @qry_recent_fxscores.sql

-- Look for good longs:

CREATE OR REPLACE VIEW good_longs AS
SELECT
pair
,AVG(score_long) avg_score_long
,AVG(score_short) avg_score_short
,MIN(ydate) mndate
,COUNT(pair)cnt
,MAX(ydate) mxdate
,ROUND(MIN(clse),4)mn_clse
,ROUND(AVG(clse),4)avg_clse
,ROUND(MAX(clse),4)mx_clse
FROM ocj
WHERE ydate > sysdate - 2/24
GROUP BY pair
HAVING(AVG(score_long) > 0.6 AND AVG(score_short) < 0.4)
ORDER BY MAX(rundate)
/

-- Look for good shorts:

CREATE OR REPLACE VIEW good_shorts AS
SELECT
pair
,AVG(score_long) avg_score_long
,AVG(score_short) avg_score_short
,MIN(ydate) mndate
,COUNT(pair)cnt
,MAX(ydate) mxdate
,ROUND(MIN(clse),4)mn_clse
,ROUND(AVG(clse),4)avg_clse
,ROUND(MAX(clse),4)mx_clse
FROM ocj
WHERE ydate > sysdate - 2/24
GROUP BY pair
HAVING(AVG(score_short) > 0.6 AND AVG(score_long) < 0.4)
ORDER BY MAX(rundate)
/


SELECT * FROM good_longs;

SELECT * FROM good_shorts;

-- Now join with recent prices:

CREATE OR REPLACE VIEW glp AS
SELECT
g.pair
,g.avg_score_long
,g.avg_score_short
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
,g.avg_score_long
,g.avg_score_short
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

