#!/bin/bash

# dl151_z3.bash

# I use this script to download many csv files and then run sqlldr.
# Frequently, I get the csv files from dl_then_svm.bash
# So I dont run this script frequently.

. /pt/s/rluck/svmspy/.orcl
. /pt/s/rluck/svmspy/.jruby

set -x

export myts=`date +%Y_%m_%d_%H_%M`

date

cd $SVMSPY/ibapi

./5min_data.bash IBM
./5min_data.bash IOC
./5min_data.bash IWM
./5min_data.bash JNJ
./5min_data.bash JOYG
./5min_data.bash JPM
./5min_data.bash JWN
./5min_data.bash KO
./5min_data.bash LFT
./5min_data.bash LMT
./5min_data.bash LVS
./5min_data.bash MAR
./5min_data.bash MCD
./5min_data.bash MDT
./5min_data.bash MDY
./5min_data.bash MEE
./5min_data.bash MET
./5min_data.bash MJN
./5min_data.bash MMM
./5min_data.bash MON
./5min_data.bash MOS
./5min_data.bash MRK
./5min_data.bash MRO
./5min_data.bash MSFT
./5min_data.bash MT
./5min_data.bash MVG
./5min_data.bash NEM
./5min_data.bash NFLX
./5min_data.bash NOC
./5min_data.bash NUE
./5min_data.bash OIH
./5min_data.bash ORCL
./5min_data.bash OXY
./5min_data.bash PAAS
./5min_data.bash PALL
./5min_data.bash PBR
./5min_data.bash PEP
./5min_data.bash PG
./5min_data.bash PM
./5min_data.bash PNC
./5min_data.bash POT
./5min_data.bash PPLT
./5min_data.bash PRU
./5min_data.bash QCOM
./5min_data.bash QQQ
./5min_data.bash RDY
./5min_data.bash RIG
./5min_data.bash RIMM
./5min_data.bash RTN
./5min_data.bash SCCO
./5min_data.bash SINA
./5min_data.bash SJM
./5min_data.bash SKX
./5min_data.bash SLB
./5min_data.bash SLV
./5min_data.bash SLW
./5min_data.bash SNDK
./5min_data.bash SOHU
./5min_data.bash SPY
./5min_data.bash STT
./5min_data.bash SU
./5min_data.bash SUN
./5min_data.bash SVM
./5min_data.bash SWC
./5min_data.bash T
./5min_data.bash TEVA
./5min_data.bash TGT
./5min_data.bash TKR
./5min_data.bash TLT
./5min_data.bash TSO
./5min_data.bash TXN
./5min_data.bash UNH
./5min_data.bash UNP
./5min_data.bash UPS
./5min_data.bash V
./5min_data.bash VALE
./5min_data.bash VECO
./5min_data.bash VLO
./5min_data.bash VMW
./5min_data.bash WDC
./5min_data.bash WFC
./5min_data.bash WFMI
./5min_data.bash WHR
./5min_data.bash WMT
./5min_data.bash WYNN
./5min_data.bash X
./5min_data.bash XLB
./5min_data.bash XLE
./5min_data.bash XLU
./5min_data.bash XOM
./5min_data.bash YUM

# Get a backup:
./expdp_ibs5min.bash > /pt/s/cron/out/expdp_ibs5min.${myts}.ibs.txt 2>&1

# Merge IB data with Dukas data:
sqt>update_di5min_stk.txt<<EOF
@update_di5min_stk.sql
EOF

./expdp_di5.bash > /pt/s/cron/out/expdp_di5.${myts}.ibs.txt 2>&1

exit

