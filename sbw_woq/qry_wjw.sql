--
-- qry_wjw.sql
--

-- I use this script to look for correlation trends for a given week
-- in a quarter for a given currency pair.

-- This script depends on cr_wjw.sql to create a table named wjw which
-- contains weekly gains and a variety of derived data.

-- I can start week of quarter (woq) on any day of the week.
-- If I start woq on a Tues, then woq_start_day is 2.

-- Start by comparing gains before 2009 to gains after 2009:
CREATE OR REPLACE VIEW qwjw10 AS
SELECT
a.pair
,a.woq
,a.day_of_week woq_start_day
,AVG(a.wgain)avg_a
,AVG(b.wgain)avg_b
,COUNT(a.pair)row_cnt
FROM
  (SELECT pair,woq,day_of_week,wgain FROM wjw WHERE ydate2<'2009-01-01')a
 ,(SELECT pair,woq,day_of_week,wgain FROM wjw WHERE ydate1>'2009-01-01')b
WHERE a.pair = b.pair AND a.woq = b.woq
GROUP BY a.pair,a.woq,a.day_of_week
-- If the pair count is low, it is noise:
HAVING COUNT(a.pair)> 123
ORDER BY a.pair,a.woq,a.day_of_week
/

-- rpt
SELECT pair,COUNT(pair),CORR(avg_a,avg_b)
FROM qwjw10
GROUP BY pair
HAVING CORR(avg_a,avg_b)>0
ORDER BY CORR(avg_a,avg_b)
/


exit

