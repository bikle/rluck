--
-- avg_recent_scores.sql
--

-- I use this script to aggregate recent scores.
-- I intend to look at output from this script before I open positions.

-- Start by joining long scores, short scores, and prices:
CREATE OR REPLACE VIEW ocj_stk AS
SELECT
l.tkrdate
,l.score
,l.rundate
,l.tkr
,l.ydate
,s.score gscore
,p.clse
FROM stkscores l
,stkscores s
,di5min_stk_c2 p
WHERE l.tkrdate = s.tkrdate
AND p.tkr = l.tkr
AND l.ydate = p.ydate
AND l.targ = 'gatt'
AND s.targ = 'gattn'
-- AND l.tkr IN('DIA','SPY','GOOG','XOM','IBM','WMT','QQQQ')
/

COLUMN clse  FORMAT 999.9999

SELECT
tkrdate
,ROUND(score,2) long_score
,ROUND(gscore,2)short_score
,rundate
,ROUND(clse,4)clse 
,CASE WHEN TO_CHAR(ydate,'dy')='fri'THEN ydate + 3
      WHEN TO_CHAR(ydate,'dy')IN
        ('mon','tue','wed','thu')   THEN ydate + 1
      ELSE NULL END clse_date
FROM ocj_stk
WHERE ydate > sysdate - 3/24
ORDER BY tkr,ydate
/

exit
