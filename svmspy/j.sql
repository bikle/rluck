--
-- avg_recent_scores.sql
--

-- I use this script to aggregate recent scores.
-- I intend to look at output from this script before I open positions.

-- This script depends on score_corr.sql
@score_corr.sql

-- Start by joining long scores, short scores, and prices:
CREATE OR REPLACE VIEW ocj_stk1 AS
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

CREATE OR REPLACE VIEW ocj_stk2 AS
SELECT
tkrdate
,tkr
,ydate
,ROUND(score_long,2) score_long
,ROUND(score_short,2)score_short
,ROUND(score_long-score_short,2) score_diff
,ROUND(clse,4)clse 
,rundate
,CASE WHEN TO_CHAR(ydate,'dy')='fri'THEN ydate + 3
      WHEN TO_CHAR(ydate,'dy')IN
        ('mon','tue','wed','thu')   THEN ydate + 1
      ELSE NULL END clse_date
FROM ocj_stk1
WHERE ydate > sysdate - 1
ORDER BY tkr,ydate
/

SELECT
tkr
,score_long
,score_short
,score_diff
,clse
,clse_date
FROM ocj_stk2
WHERE ydate > sysdate - 1/24
/


CREATE OR REPLACE VIEW ocj_stk AS
SELECT
tkrdate
,o.tkr
,ydate
,score_long
,score_short
,score_diff
,clse 
,rundate
,clse_date
,score_corr
,min_date
,ccount
,max_date
FROM ocj_stk2 o, score_corr_svmspy s
WHERE ydate > sysdate - 1
AND o.tkr = s.tkr
ORDER BY tkr,ydate
/

SELECT
CASE WHEN score_diff > 0.6 THEN'Buy'
     WHEN score_diff < -0.6 THEN'Sell  '
     ELSE NULL END action
,tkr
,score_diff
,clse
,clse_date
,score_corr
FROM ocj_stk
WHERE ydate > '2011-03-09 20:29:00'
AND score_corr > 0.1
ORDER BY tkr,ydate
/

exit
