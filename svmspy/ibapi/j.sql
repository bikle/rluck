
DROP TABLE   di5min_stk_fd;
CREATE TABLE di5min_stk_fd COMPRESS AS
SELECT
tkrdate
,tkr
,ydate
,clse
,CASE WHEN TO_CHAR(ydate,'dy')IN('mon','tue','wed','thu')THEN ydate+1
      WHEN TO_CHAR(ydate,'dy')IN('fri')THEN ydate+3
      ELSE NULL END selldate
FROM di5min_stk
/

-- Join with the future

DROP   TABLE di5min_stk_c2;

CREATE TABLE di5min_stk_c2 COMPRESS AS
SELECT
p.tkrdate
,p.tkr
,p.ydate
,p.clse
,p.selldate
,f.clse clse2
FROM di5min_stk_fd p, di5min_stk f
WHERE p.tkr || p.selldate = f.tkrdate(+)
/

-- rpt
SELECT TO_CHAR(ydate,'dy')dday,COUNT(tkr) FROM di5min_stk_fd group by TO_CHAR(ydate,'dy');
SELECT TO_CHAR(ydate,'dy')dday,COUNT(tkr) FROM di5min_stk_c2 group by TO_CHAR(ydate,'dy');

SELECT MAX(ydate)FROM di5min_stk;
SELECT MAX(ydate)FROM di5min_stk_c2;

PURGE RECYCLEBIN;
