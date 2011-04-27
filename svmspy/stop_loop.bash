#!/bin/bash

# stop_loop.bash

set -x

cd /pt/s/rluck/svmspy/

mv score1_5min_gattn.sql score1_5min_gattn.x
mv score1_5min.sql score1_5min.x
mv svmtkr.bash svmtkr.x
mv dl_then_svm.bash dl_then_svm.x
mv loop_once.bash loop_once.x
mv loop_til_sat.bash loop_til_sat.x

cd /pt/s/rluck/svmspy/ibapi
mv ./5min_data.bash ./5min_data.x
mv update_di5min_stk.sql update_di5min_stk.x
