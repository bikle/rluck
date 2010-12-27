--
-- qry_recent_fxscores.sql
--

SELECT * FROM ocj WHERE rundate> sysdate -0.5/24 ORDER BY rundate;
SELECT * FROM fxscores6       WHERE rundate> sysdate -0.5/24 ORDER BY rundate;
SELECT * FROM fxscores6_gattn WHERE rundate> sysdate -0.5/24 ORDER BY rundate;

SELECT * FROM fxscores6       WHERE rundate> sysdate -0.5/24 AND score > 0.7 ORDER BY rundate;

SELECT * FROM fxscores6_gattn WHERE rundate> sysdate -0.5/24 AND score > 0.7 ORDER BY rundate;

SELECT
s.prdate
,score
,rundate
,clse
,'GO LONG'
FROM fxscores6 s, di5min p
WHERE s.ydate = p.ydate
AND s.ydate > sysdate - 0.5/24
AND REPLACE(REPLACE(p.pair,'usd_',''),'_usd','') = s.pair
ORDER BY rundate
/

SELECT
s.prdate
,score
,rundate
,clse
,'GO SHORT'
FROM fxscores6_gattn s, di5min p
WHERE s.ydate = p.ydate
AND s.ydate > sysdate - 0.5/24
AND REPLACE(REPLACE(p.pair,'usd_',''),'_usd','') = s.pair
ORDER BY rundate
/

SELECT * FROM ocj WHERE rundate> sysdate -0.5/24 ORDER BY rundate;

exit
