--
-- set_throttle.sql
--

-- I use this script to update values in the throttle table.

-- If a pair is doing poorly, I want to set throttle to 1.
-- Else I set it to 2 or 3 if it is doing great.

-- I want the values to depend on rows returned from a join of 
-- abc_ms14 and fxscore8hp, fxscore8hp_gattn

-- If g8 is high, I want to lower bottomscore and lessen ok2open
-- and increase tval.

-- Here is some demo-SQL I use to help me find FTR:

SELECT
AVG(aud_g8)
FROM
fxscores8hp s, aud_ms14 m
WHERE s.ydate = m.ydate
AND s.pair='aud'
AND score>0.7
AND m.ydate > sysdate - 2
/



UPDATE throttle SET 
bottomscore=0.85
,ok2open=(SELECT MAX(opdate)+1/24 FROM oc WHERE pair='aud_usd')
,tval=1
WHERE pair='aud'AND longshort=1
/

SELECT pair, MAX(opdate)+1/24 FROM oc GROUP BY pair;