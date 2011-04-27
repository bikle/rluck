#!/bin/bash

. /pt/s/rluck/svmspy/.orcl
. /pt/s/rluck/svmspy/.jruby

set -x

date

cd $SVMSPY/ibapi
./5min_data.bash  IBM
./5min_data.bash  IOC
./5min_data.bash  IWM
./5min_data.bash  JNJ
./5min_data.bash  JOYG
./5min_data.bash  JPM
./5min_data.bash  JWN
./5min_data.bash  KO
./5min_data.bash  LFT
./5min_data.bash  LMT
./5min_data.bash  LVS
sqt>update_di5min_stk.txt<<EOF
@update_di5min_stk.sql
EOF
cd ..
(./5min_data.bash MAR;./5min_data.bash  MCD;./5min_data.bash MDT;./5min_data.bash MDY)&
./svmtkr.bash  IBM
./svmtkr.bash  IOC
./svmtkr.bash  IWM
./svmtkr.bash  JNJ
./svmtkr.bash  JOYG
./svmtkr.bash  JPM
./svmtkr.bash  JWN
./svmtkr.bash  KO
./svmtkr.bash  LFT
./svmtkr.bash  LMT
./svmtkr.bash  LVS

cd $SVMSPY/ibapi
# ./5min_data.bash  MAR
# ./5min_data.bash  MCD
# ./5min_data.bash  MDT
# ./5min_data.bash  MDY
./5min_data.bash  MEE
./5min_data.bash  MET
./5min_data.bash  MJN
./5min_data.bash  MMM
./5min_data.bash  MON
./5min_data.bash  MOS
./5min_data.bash  MRK
./5min_data.bash  MRO
./5min_data.bash  MSFT
./5min_data.bash  MT
./5min_data.bash  MVG
sqt>update_di5min_stk.txt<<EOF
@update_di5min_stk.sql
EOF
cd ..
./svmtkr.bash  MAR
./svmtkr.bash  MCD
./svmtkr.bash  MDT
./svmtkr.bash  MDY
./svmtkr.bash  MEE
./svmtkr.bash  MET
./svmtkr.bash  MJN
./svmtkr.bash  MMM
./svmtkr.bash  MON
./svmtkr.bash  MOS
./svmtkr.bash  MRK
./svmtkr.bash  MRO
./svmtkr.bash  MSFT
./svmtkr.bash  MT
./svmtkr.bash  MVG


cd $SVMSPY/ibapi
./5min_data.bash  NEM
./5min_data.bash  NFLX
./5min_data.bash  NOC
./5min_data.bash  NUE
./5min_data.bash  OIH
./5min_data.bash  ORCL
./5min_data.bash  OXY
sqt>update_di5min_stk.txt<<EOF
@update_di5min_stk.sql
EOF
cd ..
./svmtkr.bash  NEM
./svmtkr.bash  NFLX
./svmtkr.bash  NOC
./svmtkr.bash  NUE
./svmtkr.bash  OIH
./svmtkr.bash  ORCL
./svmtkr.bash  OXY

cd $SVMSPY/ibapi
./5min_data.bash  PAAS
./5min_data.bash  PALL
./5min_data.bash  PBR
./5min_data.bash  PEP
./5min_data.bash  PG
./5min_data.bash  PM
./5min_data.bash  PNC
./5min_data.bash  POT
./5min_data.bash  PPLT
./5min_data.bash  PRU
sqt>update_di5min_stk.txt<<EOF
@update_di5min_stk.sql
EOF
cd ..
./svmtkr.bash  PAAS
./svmtkr.bash  PALL
./svmtkr.bash  PBR
./svmtkr.bash  PEP
./svmtkr.bash  PG
./svmtkr.bash  PM
./svmtkr.bash  PNC
./svmtkr.bash  POT
./svmtkr.bash  PPLT
./svmtkr.bash  PRU

cd $SVMSPY/ibapi
./5min_data.bash  QCOM
./5min_data.bash  QQQ
./5min_data.bash  RDY
./5min_data.bash  RIG
./5min_data.bash  RIMM
./5min_data.bash  RTN
sqt>update_di5min_stk.txt<<EOF
@update_di5min_stk.sql
EOF
cd ..
./svmtkr.bash  QCOM
./svmtkr.bash  QQQ
./svmtkr.bash  RDY
./svmtkr.bash  RIG
./svmtkr.bash  RIMM
./svmtkr.bash  RTN


cd $SVMSPY/ibapi
./5min_data.bash  SCCO
./5min_data.bash  SINA
./5min_data.bash  SJM
./5min_data.bash  SKX
./5min_data.bash  SLB
./5min_data.bash  SLV
./5min_data.bash  SLW
./5min_data.bash  SNDK
./5min_data.bash  SOHU
./5min_data.bash  SPY
./5min_data.bash  STT
./5min_data.bash  SU
./5min_data.bash  SUN
./5min_data.bash  SVM
./5min_data.bash  SWC
sqt>update_di5min_stk.txt<<EOF
@update_di5min_stk.sql
EOF
cd ..
./svmtkr.bash  SCCO
./svmtkr.bash  SINA
./svmtkr.bash  SJM
./svmtkr.bash  SKX
./svmtkr.bash  SLB
./svmtkr.bash  SLV
./svmtkr.bash  SLW
./svmtkr.bash  SNDK
./svmtkr.bash  SOHU
./svmtkr.bash  SPY
./svmtkr.bash  STT
./svmtkr.bash  SU
./svmtkr.bash  SUN
./svmtkr.bash  SVM
./svmtkr.bash  SWC

cd $SVMSPY/ibapi
./5min_data.bash  T
./5min_data.bash  TEVA
./5min_data.bash  TGT
./5min_data.bash  TKR
./5min_data.bash  TLT
./5min_data.bash  TSO
./5min_data.bash  TXN
./5min_data.bash  UNH
./5min_data.bash  UNP
./5min_data.bash  UPS
sqt>update_di5min_stk.txt<<EOF
@update_di5min_stk.sql
EOF
cd ..
./svmtkr.bash  T
./svmtkr.bash  TEVA
./svmtkr.bash  TGT
./svmtkr.bash  TKR
./svmtkr.bash  TLT
./svmtkr.bash  TSO
./svmtkr.bash  TXN
./svmtkr.bash  UNH
./svmtkr.bash  UNP
./svmtkr.bash  UPS

cd $SVMSPY/ibapi
./5min_data.bash  V
./5min_data.bash  VALE
./5min_data.bash  VECO
./5min_data.bash  VLO
./5min_data.bash  VMW
./5min_data.bash  WDC
./5min_data.bash  WFC
./5min_data.bash  WFMI
./5min_data.bash  WHR
./5min_data.bash  WMT
./5min_data.bash  WYNN
sqt>update_di5min_stk.txt<<EOF
@update_di5min_stk.sql
EOF
cd ..
./svmtkr.bash  V
./svmtkr.bash  VALE
./svmtkr.bash  VECO
./svmtkr.bash  VLO
./svmtkr.bash  VMW
./svmtkr.bash  WDC
./svmtkr.bash  WFC
./svmtkr.bash  WFMI
./svmtkr.bash  WHR
./svmtkr.bash  WMT
./svmtkr.bash  WYNN

cd $SVMSPY/ibapi
./5min_data.bash  X
./5min_data.bash  XLB
./5min_data.bash  XLE
./5min_data.bash  XLU
./5min_data.bash  XOM
./5min_data.bash  YUM
sqt>update_di5min_stk.txt<<EOF
@update_di5min_stk.sql
EOF
cd ..
./svmtkr.bash  X
./svmtkr.bash  XLB
./svmtkr.bash  XLE
./svmtkr.bash  XLU
./svmtkr.bash  XOM
./svmtkr.bash  YUM
