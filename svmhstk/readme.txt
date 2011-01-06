/pt/s/rluck/svmhstk/readme.txt

I use the files in this dir to run SVM against TKR data which is collected at 1hr intervals.

The main entry point is:
  - /pt/s/rluck/svmhstk/loop_once.bash

Currently this dir depends on 2 sets of data:
  - dukas data
  - IB data

I wrestle with the dukas data here:
  - svmhstk/dukas/
  - I have all of it collected in a dpdmp file:
    - svmhstk/dukas/data4git/dukas1hr_stk_2011_0106.dpdmp.gz
    - date range: 2006-08-22 to 2011-01-05

I wrestle with the IB data here:
  - svmhstk/ibapi/
  - The table for IB data is: ibs1hr
  - I use this table for dukas data merged with IB data: di1hr_stk
  - di1hr_stk is required by stk10.sql which is the first step towards running SVM
  - The script which merges dukas and IB data is: 
    - svmhstk/ibapi/update_di1hr_stk.sql
    - That is called by: svmhstk/dl_then_svm.bash
    - That is called by: svmhstk/loop_once.bash


