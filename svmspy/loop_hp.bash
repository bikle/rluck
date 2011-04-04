#!/bin/bash

. /pt/s/rluck/svmspy/.orcl
. /pt/s/rluck/svmspy/.jruby

set -x

date

cd $SVMSPY

./dl_then_svm.bash QCOM
./dl_then_svm.bash VLO
./dl_then_svm.bash ALL
./dl_then_svm.bash BIDU

