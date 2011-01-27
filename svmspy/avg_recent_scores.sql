--
-- avg_recent_scores.sql
--

-- I use this script to aggregate recent scores.
-- I intend to look at output from this script before I open positions.

-- Start by joining long scores, short scores, and prices:
CREATE OR REPLACE VIEW ocj_stk AS
SELECT
l.tkrdate
,l.score score_long
,l.rundate
,l.tkr
,l.ydate
,s.score score_short
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
,ROUND(score_long,2) score_long
,ROUND(score_short,2)score_short
,ROUND(score_long-score_short,2) diff
,ROUND(clse,4)clse 
,rundate
,CASE WHEN TO_CHAR(ydate,'dy')='fri'THEN ydate + 3
      WHEN TO_CHAR(ydate,'dy')IN
        ('mon','tue','wed','thu')   THEN ydate + 1
      ELSE NULL END clse_date
FROM ocj_stk
WHERE ydate > sysdate - 1/24
ORDER BY tkr,ydate
/

exit
