--
-- qry_wjw.sql
--

-- I use this script to look for correlation trends for a given week
-- in a quarter for a given currency pair.

-- This script depends on cr_wjw.sql to create a table named wjw which
-- contains weekly gains and a variety of derived data.

-- I can start week of quarter (woq) on any day of the week.
-- If I start woq on a Tues, then woq_start_day is 2.

-- Start by comparing gains before 2007 to gains after 2007:
CREATE OR REPLACE VIEW qwjw2007 AS
SELECT
a.pair
,a.woq,b.qtr
,a.day_of_week woq_start_day
,AVG(a.wgain)avg_a
,AVG(b.wgain)avg_b
,COUNT(a.pair)row_cnt
FROM
  (SELECT pair,woq,qtr,day_of_week,wgain FROM wjw WHERE ydate1<'2007-01-01')a
 ,(SELECT pair,woq,qtr,day_of_week,wgain FROM wjw WHERE ydate1>'2007-01-01')b
WHERE a.pair = b.pair AND a.woq = b.woq
GROUP BY a.pair,a.woq,b.qtr,a.day_of_week
-- If the pair count is low, it is noise:
HAVING COUNT(a.pair)> 123
ORDER BY a.pair,a.woq,b.qtr,a.day_of_week
/

-- 2008 is next:
CREATE OR REPLACE VIEW qwjw2008 AS
SELECT
a.pair
,a.woq,b.qtr
,a.day_of_week woq_start_day
,AVG(a.wgain)avg_a
,AVG(b.wgain)avg_b
,COUNT(a.pair)row_cnt
FROM
  (SELECT pair,woq,qtr,day_of_week,wgain FROM wjw WHERE ydate1<'2008-01-01')a
 ,(SELECT pair,woq,qtr,day_of_week,wgain FROM wjw WHERE ydate1>'2008-01-01')b
WHERE a.pair = b.pair AND a.woq = b.woq
GROUP BY a.pair,a.woq,b.qtr,a.day_of_week
-- If the pair count is low, it is noise:
HAVING COUNT(a.pair)> 123
ORDER BY a.pair,a.woq,b.qtr,a.day_of_week
/

-- 2009 is next
CREATE OR REPLACE VIEW qwjw2009 AS
SELECT
a.pair
,a.woq,b.qtr
,a.day_of_week woq_start_day
,AVG(a.wgain)avg_a
,AVG(b.wgain)avg_b
,COUNT(a.pair)row_cnt
FROM
  (SELECT pair,woq,qtr,day_of_week,wgain FROM wjw WHERE ydate1<'2009-01-01')a
 ,(SELECT pair,woq,qtr,day_of_week,wgain FROM wjw WHERE ydate1>'2009-01-01')b
WHERE a.pair = b.pair AND a.woq = b.woq
GROUP BY a.pair,a.woq,b.qtr,a.day_of_week
-- If the pair count is low, it is noise:
HAVING COUNT(a.pair)> 123
ORDER BY a.pair,a.woq,b.qtr,a.day_of_week
/

-- 2010 is next
CREATE OR REPLACE VIEW qwjw2010 AS
SELECT
a.pair
,a.woq,b.qtr
,a.day_of_week woq_start_day
,AVG(a.wgain)avg_a
,AVG(b.wgain)avg_b
,COUNT(a.pair)row_cnt
FROM
  (SELECT pair,woq,qtr,day_of_week,wgain FROM wjw WHERE ydate1<'2010-01-01')a
 ,(SELECT pair,woq,qtr,day_of_week,wgain FROM wjw WHERE ydate1>'2010-01-01')b
WHERE a.pair = b.pair AND a.woq = b.woq
GROUP BY a.pair,a.woq,b.qtr,a.day_of_week
-- If the pair count is low, it is noise:
HAVING COUNT(a.pair)> 123
ORDER BY a.pair,a.woq,b.qtr,a.day_of_week
/

-- I now look at 2007,8,9,10:
SELECT pair,COUNT(pair),CORR(avg_a,avg_b)
FROM qwjw2007
GROUP BY pair
HAVING CORR(avg_a,avg_b)>0
ORDER BY CORR(avg_a,avg_b)
/

SELECT pair,COUNT(pair),CORR(avg_a,avg_b)
FROM qwjw2008
GROUP BY pair
HAVING CORR(avg_a,avg_b)>0
ORDER BY CORR(avg_a,avg_b)
/

SELECT pair,COUNT(pair),CORR(avg_a,avg_b)
FROM qwjw2009
GROUP BY pair
HAVING CORR(avg_a,avg_b)>0
ORDER BY CORR(avg_a,avg_b)
/

SELECT pair,COUNT(pair),CORR(avg_a,avg_b)
FROM qwjw2010
GROUP BY pair
HAVING CORR(avg_a,avg_b)>0
ORDER BY CORR(avg_a,avg_b)
/


-- usd_chf is the only pair to exhibit a correlation trend for all 4 years.

-- I look more closely at usd_chf:

SELECT * FROM
(
  SELECT
  woq_start_day
  ,woq
  ,avg_a
  ,avg_b
  ,row_cnt
  FROM qwjw2007
  WHERE avg_a * avg_b > 0
  AND pair = 'usd_chf'
  ORDER BY(avg_a * avg_b)DESC
)
WHERE rownum < 10
/

SELECT * FROM
(
  SELECT
  woq_start_day
  ,woq
  ,avg_a
  ,avg_b
  ,row_cnt
  FROM qwjw2008
  WHERE avg_a * avg_b > 0
  AND pair = 'usd_chf'
  ORDER BY(avg_a * avg_b)DESC
)
WHERE rownum < 10
/

SELECT * FROM
(
  SELECT
  woq_start_day
  ,woq
  ,avg_a
  ,avg_b
  ,row_cnt
  FROM qwjw2009
  WHERE avg_a * avg_b > 0
  AND pair = 'usd_chf'
  ORDER BY(avg_a * avg_b)DESC
)
WHERE rownum < 10
/

SELECT * FROM
(
  SELECT
  woq_start_day
  ,woq
  ,avg_a
  ,avg_b
  ,row_cnt
  FROM qwjw2010
  WHERE avg_a * avg_b > 0
  AND pair = 'usd_chf'
  ORDER BY(avg_a * avg_b)DESC
)
WHERE rownum < 10
/

-- It was difficult to pick out a "best" woq_start_day so I would just
-- pick one that seemed convenient to my schedule when I trade.

-- How about qtr?  Is there a best qtr?

SELECT * FROM
(
  SELECT
  qtr
  ,woq
  ,avg_a
  ,avg_b
  ,row_cnt
  FROM qwjw2007
  WHERE avg_a * avg_b > 0
  AND pair = 'usd_chf'
  ORDER BY(avg_a * avg_b)DESC
)
WHERE rownum < 10
/

SELECT * FROM
(
  SELECT
  qtr
  ,woq
  ,avg_a
  ,avg_b
  ,row_cnt
  FROM qwjw2008
  WHERE avg_a * avg_b > 0
  AND pair = 'usd_chf'
  ORDER BY(avg_a * avg_b)DESC
)
WHERE rownum < 10
/

SELECT * FROM
(
  SELECT
  qtr
  ,woq
  ,avg_a
  ,avg_b
  ,row_cnt
  FROM qwjw2009
  WHERE avg_a * avg_b > 0
  AND pair = 'usd_chf'
  ORDER BY(avg_a * avg_b)DESC
)
WHERE rownum < 10
/

SELECT * FROM
(
  SELECT
  qtr
  ,woq
  ,avg_a
  ,avg_b
  ,row_cnt
  FROM qwjw2010
  WHERE avg_a * avg_b > 0
  AND pair = 'usd_chf'
  ORDER BY(avg_a * avg_b)DESC
)
WHERE rownum < 10
/

-- Now look for a woq-correlation-trend which covers usd_chf, 2009, 2010:

CREATE OR REPLACE VIEW qwjw910 AS
SELECT
a.pair
,a.woq,b.qtr
,a.day_of_week woq_start_day
,AVG(a.wgain)avg_a
,AVG(b.wgain)avg_b
,COUNT(a.pair)row_cnt
FROM
  (SELECT pair,woq,qtr,day_of_week,wgain FROM wjw WHERE ydate1 BETWEEN'2009-01-01'AND'2009-12-31')a
 ,(SELECT pair,woq,qtr,day_of_week,wgain FROM wjw WHERE ydate1 BETWEEN'2010-01-01'AND'2010-12-31')b
WHERE a.pair = b.pair AND a.woq = b.woq
GROUP BY a.pair,a.woq,b.qtr,a.day_of_week
-- If the pair count is low, it is noise:
ORDER BY a.pair,a.woq,b.qtr,a.day_of_week
/

SELECT * FROM
(
  SELECT
  qtr
  ,woq
  ,avg_a
  ,avg_b
  ,row_cnt
  FROM qwjw910
  WHERE avg_a * avg_b > 0
  AND pair = 'usd_chf'
  ORDER BY(avg_a * avg_b)DESC
)
WHERE rownum < 10
/

exit

