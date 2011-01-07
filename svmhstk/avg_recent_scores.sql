--
-- avg_recent_scores.sql
--

-- I use this script to aggregate recent scores.
-- I intend to look at output from this script before I open positions.

CREATE OR REPLACE VIEW ocj_stk_1hr AS
SELECT
s.tkrdate
,s.score
,s.rundate
,s.tkr
,s.ydate
,g.score gscore
,p.clse
FROM stkscores_1hr s
,stkscores_1hr g
,di1hr_stk p
WHERE s.tkrdate = g.tkrdate
AND p.tkr = s.tkr
AND s.ydate = p.ydate
AND s.targ = 'gatt'
AND g.targ = 'gattn'
/

-- Logic discussion:

-- If I open at 17:30 on Fri
--   - I close 12 mkt hr later
--   - is [-(21 - 17.5) + 12] mkt hr after 21:00 on Fri
--   - is [-(21 - 17.5) + 12] mkt hr after 14:30 on Mon
--   - is [-(21 - 17.5) + 12 - 6.5] mkt hr after 14:30 on Tue
--   - is [-(21 - 17.5) + 5.5] mkt hr after 14:30 on Tue
--   - is 2 mkt hr after 14:30 on Tue is 16:30 on Tue
--   - is trunc(ydate + 4) + (14.5 + 5.5)/24 - ( 21/24 - (sysdate - trunc(sysdate)))
--   - this works until I hit 20:00 on Fri

COLUMN clse  FORMAT 999.9999

SELECT
tkrdate
,score long_score
,gscore short_score
,rundate
,ROUND(clse,4)clse
-- This works on Fri between 15:30 and 20:00 :
,TRUNC(ydate + 4) + (14.5 + 5.5)/24 - ( 21/24 - (ydate - TRUNC(ydate))) close_date
FROM ocj_stk_1hr
WHERE ydate > sysdate - 4/24
ORDER BY tkr,ydate
/
