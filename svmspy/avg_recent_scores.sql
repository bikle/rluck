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
AND s.tkr IN('DIA','SPY','GOOG','XOM','IBM','WMT','QQQQ')
/

COLUMN clse  FORMAT 999.9999

SELECT
tkrdate
,ROUND(score,2) long_score
,ROUND(gscore,2)short_score
,rundate
,ROUND(clse,4)clse 
-- ,ydate + 4/24 clse_date
-- ,ydate + 20.5/24 clse_date2
,CASE WHEN(ydate + 4/24)>TRUNC(ydate)+21/24 THEN'Tomorrow'
 ELSE TO_CHAR((ydate+4/24),'MM-DD HH24:MI')END clse_date
,CASE WHEN(ydate + 4/24)>TRUNC(ydate)+21/24 THEN TO_CHAR((ydate+20.5/24),'MM-DD HH24:MI')
 ELSE'Today'       END clse_date2
FROM ocj_stk
WHERE ydate > sysdate - 1/24
ORDER BY tkr,ydate
/
