#!/bin/bash

# loop_AB.bash

# I use this script to wrap dl_then_svm.bash for loop_til_sat.bash
# So, this script is called by loop_til_sat.bash

. /pt/s/rluck/svmspy/.orcl
. /pt/s/rluck/svmspy/.jruby

set -x

date

cd $SVMSPY

./dl_then_svm.bash AAPL
./dl_then_svm.bash ABT
./dl_then_svm.bash ABX
./dl_then_svm.bash ADBE
./dl_then_svm.bash AEM
./dl_then_svm.bash AFL
./dl_then_svm.bash AIG
./dl_then_svm.bash AKAM
./dl_then_svm.bash ALL
./dl_then_svm.bash AMGN
./dl_then_svm.bash AMT
./dl_then_svm.bash AMX
./dl_then_svm.bash AMZN
./dl_then_svm.bash APA
./dl_then_svm.bash APC
./dl_then_svm.bash ARG
./dl_then_svm.bash AXP
./dl_then_svm.bash BA
./dl_then_svm.bash BBT
./dl_then_svm.bash BBY
./dl_then_svm.bash BEN
./dl_then_svm.bash BHP
./dl_then_svm.bash BIDU
./dl_then_svm.bash BP
./dl_then_svm.bash BRCM
./dl_then_svm.bash BTU
./dl_then_svm.bash BUCY
