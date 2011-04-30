#!/bin/bash

# load_many2.bash

# This script is similar to load_many.bash but this script assumes that CSV data has already been collected from IB.

. /pt/s/rluck/dl15/.orcl

cd /pt/s/rluck/dl15/ibapi/

echo Get a backup.
echo I am running an export b4 starting.
set -x
export myts=`date +%Y_%m_%d_%H_%M`
echo ./expdp_ibs15min.bash
./expdp_ibs15min.bash > /pt/s/cron/out/expdp_ibs15min.${myts}.ibs.txt 2>&1

./load15min.bash T
./load15min.bash WFC
./load15min.bash ACI
./load15min.bash MRO
./load15min.bash TXN
./load15min.bash LVS
./load15min.bash YUM
./load15min.bash HAL
./load15min.bash FXI
./load15min.bash ORCL
./load15min.bash AAPL
./load15min.bash ABT
./load15min.bash ABX
./load15min.bash ADBE
./load15min.bash AEM
./load15min.bash AFL
./load15min.bash AGU
./load15min.bash AIG
./load15min.bash AKAM
./load15min.bash ALL
./load15min.bash AMGN
./load15min.bash AMT
./load15min.bash AMX
./load15min.bash AMZN
./load15min.bash APA
./load15min.bash APC
./load15min.bash ARG
./load15min.bash AXP
./load15min.bash AXU
./load15min.bash BA
./load15min.bash BBT
./load15min.bash BBY
./load15min.bash BEN
./load15min.bash BHP
./load15min.bash BIDU
./load15min.bash BP
./load15min.bash BRCM
./load15min.bash BTU
./load15min.bash BUCY
./load15min.bash CAT
./load15min.bash CDE
./load15min.bash CELG
./load15min.bash CEO
./load15min.bash CHK
./load15min.bash CLF
./load15min.bash CMI
./load15min.bash COF
./load15min.bash COP
./load15min.bash COST
./load15min.bash CREE
./load15min.bash CRM
./load15min.bash CSX
./load15min.bash CTSH
./load15min.bash CVE
./load15min.bash CVS
./load15min.bash CVX
./load15min.bash DD
./load15min.bash DE
./load15min.bash DIA
./load15min.bash DIS
./load15min.bash DNDN
./load15min.bash DTV
./load15min.bash DVN
./load15min.bash EBAY
./load15min.bash EFA
./load15min.bash EOG
./load15min.bash ESRX
./load15min.bash EWZ
./load15min.bash EXK
./load15min.bash FCX
./load15min.bash FDX
./load15min.bash FFIV
./load15min.bash FLS
./load15min.bash FSLR
./load15min.bash GD
./load15min.bash GDX
./load15min.bash GFI
./load15min.bash GG
./load15min.bash GILD
./load15min.bash GLD
./load15min.bash GOOG
./load15min.bash GS
./load15min.bash HD
./load15min.bash HES
./load15min.bash HL
./load15min.bash HOC
./load15min.bash HON
./load15min.bash HPQ
./load15min.bash IBM
./load15min.bash IOC
./load15min.bash IWM
./load15min.bash JNJ
./load15min.bash JOYG
./load15min.bash JPM
./load15min.bash JWN
./load15min.bash KO
./load15min.bash LFT
./load15min.bash LMT
./load15min.bash MAR
./load15min.bash MCD
./load15min.bash MDT
./load15min.bash MDY
./load15min.bash MEE
./load15min.bash MET
./load15min.bash MJN
./load15min.bash MMM
./load15min.bash MON
./load15min.bash MOS
./load15min.bash MRK
./load15min.bash MT
./load15min.bash MVG
./load15min.bash NEM
./load15min.bash NFLX
./load15min.bash NOC
./load15min.bash NUE
./load15min.bash OIH
./load15min.bash OXY
./load15min.bash PAAS
./load15min.bash PALL
./load15min.bash PBR
./load15min.bash PEP
./load15min.bash PG
./load15min.bash PM
./load15min.bash PNC
./load15min.bash POT
./load15min.bash PPLT
./load15min.bash PRU
./load15min.bash QCOM
./load15min.bash QQQ
./load15min.bash RDY
./load15min.bash RIG
./load15min.bash RIMM
./load15min.bash RTN
./load15min.bash SCCO
./load15min.bash SINA
./load15min.bash SJM
./load15min.bash SKX
./load15min.bash SLB
./load15min.bash SLV
./load15min.bash SLW
./load15min.bash SNDK
./load15min.bash SOHU
./load15min.bash SPY
./load15min.bash STT
./load15min.bash SU
./load15min.bash SUN
./load15min.bash SVM
./load15min.bash SWC
./load15min.bash TEVA
./load15min.bash TGT
./load15min.bash TKR
./load15min.bash TLT
./load15min.bash TSO
./load15min.bash UNH
./load15min.bash UNP
./load15min.bash UPS
./load15min.bash V
./load15min.bash VALE
./load15min.bash VECO
./load15min.bash VLO
./load15min.bash VMW
./load15min.bash WDC
./load15min.bash WFMI
./load15min.bash WHR
./load15min.bash WMT
./load15min.bash WYNN
./load15min.bash X
./load15min.bash XLB
./load15min.bash XLE
./load15min.bash XLU
./load15min.bash XOM

date

echo delete_non_rth_rows.sql
sqt>delete_non_rth_rows.txt<<EOF
@delete_non_rth_rows.sql
EOF

echo Get a backup.
./expdp_ibs15min.bash > /pt/s/cron/out/expdp_ibs15min.${myts}.ibs.txt 2>&1

date

exit
