--
-- qry4web.sql
--

-- I use this script to help me publish predictions to the web.
-- This script reports similar data as avg_recent_scores

-- ocj_stk is created here: avg_recent_scores.sql

COLUMN the_price FORMAT A40

SELECT
tkr
,score_long
,score_short
,CASE WHEN (score_short<0.2 AND score_long>0.8)THEN'Buy Long'
      WHEN (score_long<0.2 AND score_short>0.8)THEN'Sell Short'
      ELSE 'Do Nothing' END open_action
,ROUND(clse,2)||' Is price at: '||ydate the_price
,'Time to close:'    time2close
,CASE WHEN TO_CHAR(ydate,'dy')='fri'THEN ydate + 3
      WHEN TO_CHAR(ydate,'dy')IN
        ('mon','tue','wed','thu')   THEN ydate + 1
      ELSE NULL END close_time
FROM ocj_stk
WHERE ydate > sysdate - 3/24
ORDER BY tkr,ydate
/

exit

