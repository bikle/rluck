#!/bin/bash

. /pt/s/rluck/svmspy/.orcl
. /pt/s/rluck/svmspy/.jruby

set -x

date

cd $SVMSPY

./svmtkr.bash CAT
./svmtkr.bash CELG
./svmtkr.bash CLF
./svmtkr.bash CMI
./svmtkr.bash COF
./svmtkr.bash COP
./svmtkr.bash COST
./svmtkr.bash CREE
./svmtkr.bash CRM
./svmtkr.bash CSX
./svmtkr.bash CTSH
./svmtkr.bash CVS
./svmtkr.bash CVX
./svmtkr.bash DD
./svmtkr.bash DE
./svmtkr.bash DIA
./svmtkr.bash DIS
./svmtkr.bash DNDN
./svmtkr.bash DTV
./svmtkr.bash DVN
./svmtkr.bash EFA
./svmtkr.bash EOG
./svmtkr.bash ESRX
./svmtkr.bash EWZ
./svmtkr.bash FCX
./svmtkr.bash FDX
./svmtkr.bash FFIV
./svmtkr.bash FLS
./svmtkr.bash FSLR
./svmtkr.bash GDX
./svmtkr.bash GG
./svmtkr.bash GILD
./svmtkr.bash GLD
./svmtkr.bash GOOG
./svmtkr.bash GS

