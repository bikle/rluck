--
-- sjp.sql
--

-- I use this script to join score and price.
-- Often when I see a high score, I want to know what the price was when the score was calculated.

SET LINES 66
DESC fxscores8hp
DESC di5min
SET LINES 166

SELECT
prdate,score,pair FROM fxscores8hp
WHERE ydate > sysdate - 1/24
AND pair='jpy'
ORDER BY ydate
/


SELECT
prdate,clse,pair FROM di5min
WHERE ydate > sysdate - 1/24
AND pair='usd_jpy'
ORDER BY ydate
/


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
