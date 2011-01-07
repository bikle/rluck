#!/bin/bash

# loop_once.bash

# I use this script to wrap dl_then_svm.bash 
# I intend for this script to be called directly from cron.

. /pt/s/rluck/svmhstk/.orcl
. /pt/s/rluck/svmhstk/.jruby

set -x

date

cd $SVMHSTK

exit

./dl_then_svm.bash DIS
./dl_then_svm.bash EBAY
./dl_then_svm.bash GOOG
./dl_then_svm.bash HPQ
./dl_then_svm.bash IBM
./dl_then_svm.bash QQQQ
./dl_then_svm.bash WMT

exit 0

# ./dl_then_svm.bash XOM
# ./dl_then_svm.bash DIA
# ./dl_then_svm.bash SPY
