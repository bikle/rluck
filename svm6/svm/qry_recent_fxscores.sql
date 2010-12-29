--
-- qry_recent_fxscores.sql
--

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


SELECT * FROM fxscores6       WHERE rundate> sysdate -0.5/24 ORDER BY ydate;

SELECT * FROM fxscores6_gattn WHERE rundate> sysdate -0.5/24 ORDER BY ydate;

SELECT * FROM fxscores6       WHERE rundate> sysdate -0.5/24 AND score > 0.7 ORDER BY ydate;

SELECT * FROM fxscores6_gattn WHERE rundate> sysdate -0.5/24 AND score > 0.7 ORDER BY ydate;

COLUMN clse  FORMAT 999.9999

SELECT
s.prdate
,score long_score
,gscore short_score
,rundate
,ROUND(clse,4)clse 
FROM ocj s, di5min p
WHERE s.ydate = p.ydate
AND s.ydate > sysdate - 2/24
AND REPLACE(REPLACE(p.pair,'usd_',''),'_usd','') = s.pair
ORDER BY s.ydate
/

exit
