#!/bin/bash

# loop_svm.bash

# I use this loop (instead of cron) to launch SVM scripts.

. /pt/s/rluck/svm4hp/.jruby

set -x 
cd $SVM4HP

## while [ 1 ]
## do
  export myts=`date +%Y_%m_%d_%H_%M`
  date
  echo hello
  /pt/s/api/f/5min_data/run5min_data.bash > /pt/s/cron/out/run5min_data.${myts}.txt 2>&1
  sleep 5
  ./z2_every10.bash > /pt/s/cron/out/./z2_every10.${myts}.txt 2>&1
## done
