
-- get rounded hr

select 0+TO_CHAR(sysdate,'HH24')hh from dual;

select 0+TO_CHAR(
  ROUND(sysdate,'HH24')
  ,'HH24')rhh
from dual
/

select 0+TO_CHAR( ROUND(sysdate,'HH24') ,'HH24')rhh
from dual
/

select ROUND( (sysdate - trunc(sysdate))*24*60 )mpm from dual;

