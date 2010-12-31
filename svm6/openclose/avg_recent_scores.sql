-- Look at an avg of recent scores:


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

-- Look for good longs:
SELECT
s.pair
,COUNT(s.pair)cnt
,AVG(score) long_score
,AVG(gscore) short_score
,MIN(rundate)
,MAX(rundate)
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

exit
