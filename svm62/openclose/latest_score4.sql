--
-- latest_score4.sql
--

-- I use this script to get the latest score for a specific pair.

-- Look for long score first:

SELECT
'longscore'
||'matchthis'
,score
,rundate
,ydate
FROM fxscores6
WHERE pair = '&1'
AND ydate = 
(
  SELECT MAX(ydate)
  FROM fxscores6
  WHERE pair = '&1'
)
/

-- Look for short score:

SELECT
'shortscore'
||'matchthis'
,score
,rundate
,ydate
FROM fxscores6_gattn
WHERE pair = '&1'
AND ydate = 
(
  SELECT MAX(ydate)
  FROM fxscores6_gattn
  WHERE pair = '&1'
)
/

exit

