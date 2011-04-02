#!/bin/bash

. /pt/s/rluck/svmspy/.orcl
. /pt/s/rluck/svmspy/.jruby

set -x

date

cd $SVMSPY

./svmtkr.bash AXU
# ./svmtkr.bash CVE
# ./svmtkr.bash DIA
# ./svmtkr.bash DIS
./svmtkr.bash DTV
./svmtkr.bash EBAY
./svmtkr.bash EFA
./svmtkr.bash EXK
exit

./svmtkr.bash GDX
./svmtkr.bash GFI
./svmtkr.bash LFT
./svmtkr.bash MOS
./svmtkr.bash MVG
./svmtkr.bash PBR
./svmtkr.bash PM
./svmtkr.bash SKX
./svmtkr.bash SVM
./svmtkr.bash VMW
