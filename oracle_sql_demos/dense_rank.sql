
-- Here:
SELECT pair, ydate, mvgsum,dr FROM
(
  SELECT
  pair
  , ydate
  , mvgsum
  ,DENSE_RANK()OVER(PARTITION BY pair ORDER BY ydate DESC)dr
  FROM sjg12 ORDER BY pair,ydate DESC
)
WHERE ydate > '2010-10-06'
AND dr < 6
/

-- output:

-- 12:11:24 SQL> SELECT pair, ydate, mvgsum,dr FROM
-- 12:11:24   2  (
-- 12:11:24   3    SELECT
-- 12:11:24   4    pair
-- 12:11:24   5    , ydate
-- 12:11:24   6    , mvgsum
-- 12:11:24   7    ,DENSE_RANK()OVER(PARTITION BY pair ORDER BY ydate DESC)dr
-- 12:11:24   8    FROM sjg12 ORDER BY pair,ydate DESC
-- 12:11:24   9  )
-- 12:11:24  10  WHERE ydate > '2010-10-06'
-- 12:11:24  11  AND dr < 6
-- 12:11:24  12  /
-- 
-- PAI YDATE                   MVGSUM         DR
-- --- ------------------- ---------- ----------
-- aud 2010-10-08 15:00:00    .024725          1
-- aud 2010-10-08 14:00:00    .025675          2
-- aud 2010-10-08 13:00:00    .026325          3
-- aud 2010-10-08 06:00:00      .0347          4
-- aud 2010-10-08 05:00:00    .036175          5
-- cad 2010-10-06 17:00:00    .009925          1
-- cad 2010-10-06 09:00:00    .015225          2
-- cad 2010-10-06 08:00:00     .02005          3
-- cad 2010-10-06 07:00:00      .0244          4
-- cad 2010-10-06 04:00:00      .0285          5
-- chf 2010-10-08 12:00:00      .0184          1
-- chf 2010-10-07 06:00:00    .014875          2
-- chf 2010-10-06 23:00:00    .014975          3
-- chf 2010-10-06 17:00:00     .01805          4
-- chf 2010-10-06 16:00:00      .0186          5
-- eca 2010-10-06 02:00:00 .003482989          1
-- egb 2010-10-07 02:00:00 .019630344          1
-- egb 2010-10-06 11:00:00 .021837845          2
-- egb 2010-10-06 10:00:00 .020068516          3
-- egb 2010-10-06 09:00:00 .017610469          4
-- ejp 2010-10-08 11:00:00 .199110906          1

--
-- /pt/z2/api/stk/cr_fake_today.sql
--

-- Near the end of mkt close I want to create a fake day from the data I have so far for today.

-- This should get about 6 or 7 rows for each tkr for today
CREATE OR REPLACE VIEW fd10 AS
SELECT
tkr
,ydate ydate0
--The fake time is 4pm NY time:
,TRUNC(ydate)+16/24 ydate
,yprice
,highp
,lowp
,vol vol0
,SUM(vol)OVER(PARTITION BY tkr ORDER BY ydate)sum_vol
-- This gets me most recent vol and yprice:
,DENSE_RANK()OVER(PARTITION BY tkr ORDER BY ydate DESC)dr_ydate
-- This gets me highp:
,DENSE_RANK()OVER(PARTITION BY tkr ORDER BY highp DESC)dr_highp
-- This gets me lowp:
,DENSE_RANK()OVER(PARTITION BY tkr ORDER BY lowp)      dr_lowp
FROM stkib2
-- This constrains me to most recent day of data:
WHERE TRUNC(ydate)=(SELECT MAX(TRUNC(ydate))FROM stkib2)
/

-- rpt
-- I should see about 128 tkrs for today:
SELECT tkr,COUNT(tkr),MAX(ydate)FROM fd10 GROUP BY tkr;

-- See SPY:
SELECT * FROM fd10 WHERE tkr='SPY'ORDER BY ydate;

-- Get closing yprice to be at: WHERE dr_ydate = 1
SELECT tkr,ydate0,yprice,dr_ydate FROM fd10 WHERE tkr='SPY'ORDER BY ydate0 DESC;

-- Get highp to be at: WHERE dr_highp = 1
SELECT tkr,ydate0,highp,dr_highp FROM fd10 WHERE tkr='SPY'ORDER BY highp DESC;

-- Get lowp to be at: WHERE dr_lowp = 1
SELECT tkr,ydate0,lowp,dr_lowp FROM fd10 WHERE tkr='SPY'ORDER BY lowp;

-- Look at sum_vol. It is like yprice. I want the most recent value.
SELECT tkr,ydate0,sum_vol,dr_ydate FROM fd10 WHERE tkr='SPY'ORDER BY ydate0 DESC;

-- Merge it all together:
CREATE OR REPLACE VIEW fd12 AS
SELECT
yp.tkr||yp.ydate tkrdate
,yp.tkr
,yp.ydate
,yp.yprice
,yp.sum_vol vol
,hp.highp
,lp.lowp
FROM fd10 yp, fd10 hp, fd10 lp
WHERE yp.tkr = hp.tkr AND yp.tkr = lp.tkr
AND yp.dr_ydate = 1
AND hp.dr_highp = 1
AND lp.dr_lowp  = 1
/

DROP TABLE fakeday;
-- CREATE OR REPLACE VIEW fakeday AS
CREATE TABLE fakeday COMPRESS AS
SELECT
tkrdate
,MAX(tkr)tkr
,MAX(ydate)ydate
,MAX(yprice)yprice
,MAX(vol)vol
,MAX(highp)highp
,MAX(lowp)lowp
FROM fd12
GROUP BY tkrdate
/

-- rpt
SELECT tkrdate,tkr,ydate,yprice,vol,highp,lowp FROM fakeday WHERE tkr='SPY';

SET lines 66
DESC fakeday

-- Look for count of dups
SELECT COUNT(tkrdate)FROM
  (SELECT tkrdate,COUNT(tkrdate)cnt FROM fakeday GROUP BY tkrdate HAVING COUNT(tkrdate)>1)
/

-- Look at actual dups
SELECT * FROM fakeday WHERE tkrdate IN
  (SELECT tkrdate FROM
    (SELECT tkrdate,COUNT(tkrdate)cnt FROM fakeday GROUP BY tkrdate HAVING COUNT(tkrdate)>1));

-- Adjust vol with a rough estimate.

UPDATE fakeday SET vol=vol*150;

-- Look at fakeday
SELECT * FROM fakeday ORDER BY tkrdate;

select vol from fakeday where tkr='SPY';

exit
