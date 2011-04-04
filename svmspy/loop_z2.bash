#!/bin/bash

. /pt/s/rluck/svmspy/.orcl
. /pt/s/rluck/svmspy/.jruby

set -x

date

cd $SVMSPY

./dl_then_svm.bash AMZN
./dl_then_svm.bash AXU
./dl_then_svm.bash BRCM
./dl_then_svm.bash COF
./dl_then_svm.bash CVE
./dl_then_svm.bash DIA
./dl_then_svm.bash DIS
./dl_then_svm.bash DTV
./dl_then_svm.bash EBAY
./dl_then_svm.bash EFA
./dl_then_svm.bash EXK
./dl_then_svm.bash FCX
./dl_then_svm.bash FFIV
./dl_then_svm.bash FSLR
./dl_then_svm.bash GDX
./dl_then_svm.bash GFI
./dl_then_svm.bash GLD
./dl_then_svm.bash GOOG
./dl_then_svm.bash GS
./dl_then_svm.bash HPQ
./dl_then_svm.bash IBM
./dl_then_svm.bash IOC
./dl_then_svm.bash IWM
./dl_then_svm.bash KO
./dl_then_svm.bash LFT
./dl_then_svm.bash MJN
./dl_then_svm.bash MOS
./dl_then_svm.bash MVG
