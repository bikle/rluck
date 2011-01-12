
SELECT 
MIN(ydate)
,COUNT(ydate)
,MAX(ydate)
FROM stkscores
WHERE targ='gatt'AND tkr='XLB'
/

SELECT 
MIN(s.ydate)
,COUNT(s.ydate)
,MAX(s.ydate)
FROM stkscores s, stk_ms m
WHERE targ='gatt'AND m.tkr='XLB'
AND s.tkr = m.tkr
AND s.ydate = m.ydate
/

SELECT 
MIN(s.ydate)
,COUNT(s.ydate)
,MAX(s.ydate)
FROM stkscores s, stk_ms m
WHERE targ='gattn'AND m.tkr='XLB'
AND s.tkr = m.tkr
AND s.ydate = m.ydate
/





