#!/bin/bash

# loop_AB.bash

# I use this script to wrap dl_then_svm.bash for loop_til_sat.bash
# So, this script is called by loop_til_sat.bash

. /pt/s/rluck/svmspy/.orcl
. /pt/s/rluck/svmspy/.jruby

set -x

date

cd $SVMSPY

./svmtkr.bash AAPL
./svmtkr.bash ABT
./svmtkr.bash ABX
./svmtkr.bash ADBE
./svmtkr.bash AEM
./svmtkr.bash AFL
./svmtkr.bash AIG
./svmtkr.bash AKAM
./svmtkr.bash ALL
./svmtkr.bash AMGN
./svmtkr.bash AMT
./svmtkr.bash AMX
./svmtkr.bash AMZN
./svmtkr.bash APA
./svmtkr.bash APC
./svmtkr.bash ARG
./svmtkr.bash AXP
./svmtkr.bash BA
./svmtkr.bash BBT
./svmtkr.bash BBY
./svmtkr.bash BEN
./svmtkr.bash BHP
./svmtkr.bash BIDU
./svmtkr.bash BP
./svmtkr.bash BRCM
./svmtkr.bash BTU
./svmtkr.bash BUCY
