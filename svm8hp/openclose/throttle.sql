--
-- throttle.sql
--

-- This contains SQL which helps me throttle the rate at which I open positions.

-- Here is the throttle behavior I want:

-- Throttle settings:
--   1 is go slow, 2 faster, 3 fastest

-- If throttle = 1:
--   - open if score > 0.8
--   - open if time since last xoc > 1/24 of a day
-- 
-- If throttle = 2:
--   - open if score > 0.75
--   - open if time since last xoc > 0.5/24 of a day
-- 
-- If throttle = 3
--   - open if score > 0.7

-- Here is some throttle logic:
-- First, measure full-throttle-rate-of-return (FTR)
-- If FTR is unknown or negative:
--   set throttle = 1
-- If FTR is positive:
--   set throttle = 2
-- If FTR is > 1 pip / hour:
--   set throttle = 3

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


