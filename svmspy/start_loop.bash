#!/bin/bash

# start_loop.bash

set -x

cd /pt/s/rluck/svmspy/

mv dl_then_svm.x dl_then_svm.bash
mv score1_5min.x score1_5min.sql
mv score1_5min_gattn.x score1_5min_gattn.sql
mv svmtkr.x svmtkr.bash
mv loop_once.x loop_once.bash
mv loop_til_sat.x loop_til_sat.bash

cd /pt/s/rluck/svmspy/ibapi
mv ./5min_data.x ./5min_data.bash
mv update_di5min_stk.x update_di5min_stk.sql
