--
-- avg_recent_scores.sql
--

-- I use this script to aggregate recent scores.
-- I intend to look at output from this script before I open positions.

CREATE OR REPLACE VIEW ocj_stk AS
SELECT
s.tkrdate
,s.score
,s.rundate
,s.tkr
,s.ydate
,g.score gscore
,p.clse
FROM stkscores s
,stkscores g
,di5min_stk p
WHERE s.tkrdate = g.tkrdate
AND p.tkr = s.tkr
AND s.ydate = p.ydate
AND s.targ = 'gatt'
AND g.targ = 'gattn'
/

COLUMN clse  FORMAT 999.9999

SELECT
tkrdate
,score long_score
,gscore short_score
,rundate
,ROUND(clse,4)clse 
,ydate + 4/24 clse_date
,ydate + 24.5/24 clse_date2
FROM ocj_stk
WHERE ydate > sysdate - 1/24
ORDER BY tkr,ydate
/
