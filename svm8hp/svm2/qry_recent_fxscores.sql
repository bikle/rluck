--
-- qry_recent_fxscores.sql
--

SELECT * FROM fxscores8hp       WHERE rundate> sysdate -4/24 ORDER BY ydate;
SELECT * FROM fxscores8hp_gattn WHERE rundate> sysdate -4/24 ORDER BY ydate;

SELECT * FROM fxscores8hp       WHERE rundate> sysdate -4/24 AND score > 0.7 ORDER BY ydate;

SELECT * FROM fxscores8hp_gattn WHERE rundate> sysdate -4/24 AND score > 0.7 ORDER BY ydate;

SELECT
s.prdate
,score
,rundate
,clse
,'GO LONG'
FROM fxscores8hp s, di5min p
WHERE s.ydate = p.ydate
AND s.ydate > sysdate - 0.5/24
AND REPLACE(REPLACE(p.pair,'usd_',''),'_usd','') = s.pair
/

SELECT
s.prdate
,score
,rundate
,clse
,'GO SHORT'
FROM fxscores8hp_gattn s, di5min p
WHERE s.ydate = p.ydate
AND s.ydate > sysdate - 0.5/24
AND REPLACE(REPLACE(p.pair,'usd_',''),'_usd','') = s.pair
/

exit
