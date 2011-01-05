#!/bin/bash

# loop_once.bash

# I use this script to wrap dl_then_svm.bash for loop_til_sat.bash
# So, this script is called by loop_til_sat.bash

. /pt/s/rluck/svmspy/.orcl
. /pt/s/rluck/svmspy/.jruby

set -x

date

cd $SVMSPY

./dl_then_svm.bash GOOG
./dl_then_svm.bash SPY
./dl_then_svm.bash QQQQ
./dl_then_svm.bash DIA
./dl_then_svm.bash WMT
./dl_then_svm.bash XOM
./dl_then_svm.bash IBM

exit 0

# ./dl_then_svm.bash DIS
# ./dl_then_svm.bash EBAY
# ./dl_then_svm.bash HPQ
