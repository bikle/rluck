
select count(*)from stkscores WHERE tkr='DIA';

select count(*)from stk_ms where ydate not in 
  (SELECT ydate FROM stkscores WHERE targ='gatt'AND tkr='DIA')
/
