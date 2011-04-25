#!/bin/bash

. /pt/s/rluck/svmspy/.orcl
. /pt/s/rluck/svmspy/.jruby

set -x

date

cd $SVMSPY/ibapi
./5min_data.bash  AAPL
./5min_data.bash  ABT
./5min_data.bash  ABX
./5min_data.bash  ADBE
./5min_data.bash  AEM
./5min_data.bash  AFL
./5min_data.bash  AGU
./5min_data.bash  AIG
./5min_data.bash  AKAM
./5min_data.bash  ALL
./5min_data.bash  AMGN
./5min_data.bash  AMT
./5min_data.bash  AMX
./5min_data.bash  AMZN
./5min_data.bash  APA
./5min_data.bash  APC
./5min_data.bash  ARG
./5min_data.bash  AXP
./5min_data.bash  AXU
sqt>update_di5min_stk.txt<<EOF
@update_di5min_stk.sql
EOF
cd ..
./svmtkr.bash  AAPL
./svmtkr.bash  ABT
./svmtkr.bash  ABX
./svmtkr.bash  ADBE
./svmtkr.bash  AEM
./svmtkr.bash  AFL
./svmtkr.bash  AGU
./svmtkr.bash  AIG
./svmtkr.bash  AKAM
./svmtkr.bash  ALL
./svmtkr.bash  AMGN
./svmtkr.bash  AMT
./svmtkr.bash  AMX
./svmtkr.bash  AMZN
./svmtkr.bash  APA
./svmtkr.bash  APC
./svmtkr.bash  ARG
./svmtkr.bash  AXP
./svmtkr.bash  AXU

cd $SVMSPY/ibapi
./5min_data.bash  BA
./5min_data.bash  BBT
./5min_data.bash  BBY
./5min_data.bash  BEN
./5min_data.bash  BHP
./5min_data.bash  BIDU
./5min_data.bash  BP
./5min_data.bash  BRCM
./5min_data.bash  BTU
./5min_data.bash  BUCY
sqt>update_di5min_stk.txt<<EOF
@update_di5min_stk.sql
EOF
cd ..
./svmtkr.bash  BA
./svmtkr.bash  BBT
./svmtkr.bash  BBY
./svmtkr.bash  BEN
./svmtkr.bash  BHP
./svmtkr.bash  BIDU
./svmtkr.bash  BP
./svmtkr.bash  BRCM
./svmtkr.bash  BTU
./svmtkr.bash  BUCY

cd $SVMSPY/ibapi
./5min_data.bash  CAT
./5min_data.bash  CDE
./5min_data.bash  CELG
./5min_data.bash  CEO
./5min_data.bash  CHK
./5min_data.bash  CLF
./5min_data.bash  CMI
./5min_data.bash  COF
./5min_data.bash  COP
./5min_data.bash  COST
./5min_data.bash  CREE
./5min_data.bash  CRM
./5min_data.bash  CSX
./5min_data.bash  CTSH
./5min_data.bash  CVE
./5min_data.bash  CVS
./5min_data.bash  CVX
sqt>update_di5min_stk.txt<<EOF
@update_di5min_stk.sql
EOF
cd ..
./svmtkr.bash  CAT
./svmtkr.bash  CDE
./svmtkr.bash  CELG
./svmtkr.bash  CEO
./svmtkr.bash  CHK
./svmtkr.bash  CLF
./svmtkr.bash  CMI
./svmtkr.bash  COF
./svmtkr.bash  COP
./svmtkr.bash  COST
./svmtkr.bash  CREE
./svmtkr.bash  CRM
./svmtkr.bash  CSX
./svmtkr.bash  CTSH
./svmtkr.bash  CVE
./svmtkr.bash  CVS
./svmtkr.bash  CVX

cd $SVMSPY/ibapi
./5min_data.bash  DD
./5min_data.bash  DE
./5min_data.bash  DIA
./5min_data.bash  DIS
./5min_data.bash  DNDN
./5min_data.bash  DTV
./5min_data.bash  DVN
sqt>update_di5min_stk.txt<<EOF
@update_di5min_stk.sql
EOF
cd ..
./svmtkr.bash  DD
./svmtkr.bash  DE
./svmtkr.bash  DIA
./svmtkr.bash  DIS
./svmtkr.bash  DNDN
./svmtkr.bash  DTV
./svmtkr.bash  DVN

date
cd $SVMSPY/ibapi
./5min_data.bash  EBAY
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
./svmtkr.bash  EBAY
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
