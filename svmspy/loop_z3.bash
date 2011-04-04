#!/bin/bash

# loop_some.bash

. /pt/s/rluck/svmspy/.orcl
. /pt/s/rluck/svmspy/.jruby

set -x

date

cd $SVMSPY

./dl_then_svm.bash NEM
./dl_then_svm.bash NFLX
./dl_then_svm.bash ORCL
./dl_then_svm.bash PALL
./dl_then_svm.bash PBR
./dl_then_svm.bash PM
./dl_then_svm.bash POT
./dl_then_svm.bash PPLT
./dl_then_svm.bash QQQ
./dl_then_svm.bash RIMM
./dl_then_svm.bash SJM
./dl_then_svm.bash SKX
./dl_then_svm.bash SLB
./dl_then_svm.bash SLV
./dl_then_svm.bash SNDK
./dl_then_svm.bash SPY
./dl_then_svm.bash SVM
./dl_then_svm.bash SWC
./dl_then_svm.bash TLT
./dl_then_svm.bash V
./dl_then_svm.bash VECO
./dl_then_svm.bash VMW
./dl_then_svm.bash WDC
./dl_then_svm.bash WMT
./dl_then_svm.bash XLB
./dl_then_svm.bash XLE
./dl_then_svm.bash XOM
