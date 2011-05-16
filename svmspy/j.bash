#!/bin/bash

. /pt/s/rluck/svmspy/.orcl
. /pt/s/rluck/svmspy/.jruby

set -x

date

cd $SVMSPY

./svmtkr.bash QCOM
./svmtkr.bash QQQ
./svmtkr.bash RDY
./svmtkr.bash RIG
./svmtkr.bash RIMM
./svmtkr.bash RTN
./svmtkr.bash SCCO
./svmtkr.bash SINA
./svmtkr.bash SJM
./svmtkr.bash SKX
./svmtkr.bash SLB
./svmtkr.bash SLV
./svmtkr.bash SLW
./svmtkr.bash SNDK
./svmtkr.bash SOHU
./svmtkr.bash SPY
./svmtkr.bash STT
./svmtkr.bash SU
./svmtkr.bash SUN
./svmtkr.bash SVM
./svmtkr.bash SWC
