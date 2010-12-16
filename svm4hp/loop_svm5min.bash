#!/bin/bash

# loop_svm5min.bash

# I use this loop (instead of cron) to launch SVM scripts.

. /pt/s/rluck/svm4hp/.jruby

set -x 
cd $SVM4HP

while [ 1 ]
do
  export myts=`date +%Y_%m_%d_%H_%M`
  date
  echo hello
  ./z2_every5.bash > /pt/s/cron/out/z2_every5.${myts}.txt 2>&1
  date
done
