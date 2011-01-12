#!/bin/bash

# loop_once.bash

# I use this script to wrap dl_then_svm.bash for loop_til_sat.bash
# So, this script is called by loop_til_sat.bash

. /pt/s/rluck/svmspy/.orcl
. /pt/s/rluck/svmspy/.jruby

set -x

date

cd $SVMSPY

./dl_then_svm.bash SINA
./dl_then_svm.bash SJM
./dl_then_svm.bash SKX
./dl_then_svm.bash SLB
./dl_then_svm.bash SLV
./dl_then_svm.bash SNDK
./dl_then_svm.bash SPY
./dl_then_svm.bash STT
./dl_then_svm.bash SUN
./dl_then_svm.bash TEVA
./dl_then_svm.bash TGT
./dl_then_svm.bash TKR
./dl_then_svm.bash TLT


exit 0
