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
FROM fxscores6 s,fxscores6_gattn g
WHERE s.prdate = g.prdate
-- done already

-- 1st I show the actual scores:
@qry_recent_fxscores.sql

-- Look for good longs:
SELECT
s.pair
,AVG(score) long_score
,AVG(gscore) short_score
,MIN(s.ydate)
,COUNT(s.pair)cnt
,MAX(s.ydate)
,ROUND(MIN(clse),4)mn_clse
,ROUND(AVG(clse),4)avg_clse
,ROUND(MAX(clse),4)mx_clse
FROM ocj s, di5min p
WHERE s.ydate = p.ydate
AND s.ydate > sysdate - 2/24
AND REPLACE(REPLACE(p.pair,'usd_',''),'_usd','') = s.pair
GROUP BY s.pair
HAVING(AVG(score) > 0.64 AND AVG(gscore) < 0.3)
ORDER BY MAX(rundate)
/

-- Look for good shorts:
SELECT
s.pair
,AVG(score) long_score
,AVG(gscore) short_score
,MIN(s.ydate)
,COUNT(s.pair)cnt
,MAX(s.ydate)
,ROUND(MIN(clse),4)mn_clse
,ROUND(AVG(clse),4)avg_clse
,ROUND(MAX(clse),4)mx_clse
FROM ocj s, di5min p
WHERE s.ydate = p.ydate
AND s.ydate > sysdate - 2/24
AND REPLACE(REPLACE(p.pair,'usd_',''),'_usd','') = s.pair
GROUP BY s.pair
HAVING(AVG(gscore) > 0.64 AND AVG(score) < 0.3)
ORDER BY MAX(rundate)
/

exit
