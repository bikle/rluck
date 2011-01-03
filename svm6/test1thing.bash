#!/bin/bash

# test1thing.bash


. /pt/s/rluck/svm6/.orcl
. /pt/s/rluck/svm6/.jruby

set -x 
export myts=`date +%Y_%m_%d_%H_%M`

cd $SVM6

cd svm
./egb_svm.bash > /pt/s/cron/out/egb_svm.${myts}.txt 2>&1

exit
