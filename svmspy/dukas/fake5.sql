--
-- fake5.sql
--

-- I use this script to fill dukas5min_stk with data from dukas10min_stk.

DROP TABLE dukas5min_stk;

PURGE RECYCLEBIN;

exit

CREATE TABLE dukas5min_stk COMPRESS AS
SELECT tkr,ydate,clse FROM
(
  SELECT
  tkr
  ,ydate
  ,clse
  FROM dukas10min_stk
  UNION
  SELECT tkr,ydate,clse FROM
  (
    SELECT
    tkr
    ,ydate-5/60/24 ydate
    ,LAG(clse,1,NULL)OVER(PARTITION BY tkr ORDER BY ydate) lg
    ,(LAG(clse,1,NULL)OVER(PARTITION BY tkr ORDER BY ydate)+clse)/2 clse
    FROM dukas10min_stk
  )
  WHERE lg > 0
)
ORDER BY tkr,ydate
/

--rpt 

SELECT
tkr
,TO_CHAR(ydate,'MM')mnth
,COUNT(tkr)
FROM dukas5min_stk
GROUP BY
tkr
,TO_CHAR(ydate,'MM')
ORDER BY
tkr
,TO_CHAR(ydate,'MM')
/


