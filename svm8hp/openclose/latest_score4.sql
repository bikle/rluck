--
-- latest_score4.sql
--

-- I use this script to get the latest score for a specific pair.

SELECT
'longscore'
||'matchthis'
,score
,rundate
,ydate
FROM fxscores8hp_gattn
WHERE pair = '&1'
AND ydate = 
(
  SELECT MAX(ydate)
  FROM fxscores8hp_gattn
  WHERE pair = '&1'
)
/

exit

