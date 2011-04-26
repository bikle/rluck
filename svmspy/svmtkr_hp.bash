#!/bin/bash

. /pt/s/rluck/svmspy/.orcl
. /pt/s/rluck/svmspy/.jruby

set -x

date

cd $SVMSPY

./svmtkr.bash PAAS
./svmtkr.bash PALL
./svmtkr.bash PBR
./svmtkr.bash PEP
./svmtkr.bash PG
./svmtkr.bash PM
./svmtkr.bash PNC
./svmtkr.bash POT
./svmtkr.bash PPLT
./svmtkr.bash PRU
