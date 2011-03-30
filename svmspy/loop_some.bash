#!/bin/bash

# loop_some.bash

. /pt/s/rluck/svmspy/.orcl
. /pt/s/rluck/svmspy/.jruby

set -x

date

cd $SVMSPY

./dl_then_svm.bash AXU
./dl_then_svm.bash CVE
./dl_then_svm.bash DIA
./dl_then_svm.bash DIS
./dl_then_svm.bash DTV
./dl_then_svm.bash EBAY
./dl_then_svm.bash EFA
./dl_then_svm.bash EXK
./dl_then_svm.bash GDX
./dl_then_svm.bash GFI
./dl_then_svm.bash LFT
./dl_then_svm.bash MOS
./dl_then_svm.bash MVG
./dl_then_svm.bash PBR
./dl_then_svm.bash PM
./dl_then_svm.bash SKX
./dl_then_svm.bash SVM
./dl_then_svm.bash VMW
