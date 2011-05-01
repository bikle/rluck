
select * from ystk where tkr='SVM' AND ydate between '2011-02-17'and'2011-02-28' order by ydate

select * from ibs5min where tkr='SVM' AND ydate between '2011-02-17'and'2011-03-01' order by ydate

select * from ibs5min where tkr='FCX' AND to_char(ydate,'hh24:mi')='19:00' order by ydate;

