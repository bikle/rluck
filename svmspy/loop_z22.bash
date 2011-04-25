#!/bin/bash

. /pt/s/rluck/svmspy/.orcl
. /pt/s/rluck/svmspy/.jruby

set -x

date
cd $SVMSPY/ibapi
./5min_data.bash  HAL
./5min_data.bash  HD
./5min_data.bash  HES
./5min_data.bash  HL
./5min_data.bash  HOC
./5min_data.bash  HON
./5min_data.bash  HPQ
sqt>update_di5min_stk.txt<<EOF
@update_di5min_stk.sql
EOF
cd ..
./svmtkr.bash HAL
./svmtkr.bash HD
./svmtkr.bash HES
./svmtkr.bash HL
./svmtkr.bash HOC
./svmtkr.bash HON
./svmtkr.bash HPQ

exit

cd $SVMSPY/ibapi
./5min_data.bash  GD
./5min_data.bash  GDX
./5min_data.bash  GFI
./5min_data.bash  GG
./5min_data.bash  GILD
./5min_data.bash  GLD
./5min_data.bash  GOOG
./5min_data.bash  GS
sqt>update_di5min_stk.txt<<EOF
@update_di5min_stk.sql
EOF
cd ..
./svmtkr.bash  GD
./svmtkr.bash  GDX
./svmtkr.bash  GFI
./svmtkr.bash  GG
./svmtkr.bash  GILD
./svmtkr.bash  GLD
./svmtkr.bash  GOOG
./svmtkr.bash  GS

exit

date
cd $SVMSPY/ibapi
./5min_data.bash  EFA
./5min_data.bash  EOG
./5min_data.bash  ESRX
./5min_data.bash  EWZ
./5min_data.bash  EXK
./5min_data.bash  FCX
./5min_data.bash  FDX
./5min_data.bash  FFIV
./5min_data.bash  FLS
./5min_data.bash  FSLR
./5min_data.bash  FXI
sqt>update_di5min_stk.txt<<EOF
@update_di5min_stk.sql
EOF
cd ..
./svmtkr.bash  EFA
./svmtkr.bash  EOG
./svmtkr.bash  ESRX
./svmtkr.bash  EWZ
./svmtkr.bash  EXK
./svmtkr.bash  FCX
./svmtkr.bash  FDX
./svmtkr.bash  FFIV
./svmtkr.bash  FLS
./svmtkr.bash  FSLR
./svmtkr.bash  FXI

date

