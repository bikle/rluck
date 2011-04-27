#!/bin/bash

# dl151_z2.bash

# I use this script to download many csv files and then run sqlldr.
# Frequently, I get the csv files from dl_then_svm.bash
# So I dont run this script frequently.

. /pt/s/rluck/svmspy/.orcl
. /pt/s/rluck/svmspy/.jruby

set -x

export myts=`date +%Y_%m_%d_%H_%M`

date

cd $SVMSPY/ibapi

./5min_data.bash AAPL
./5min_data.bash ABT
./5min_data.bash ABX
./5min_data.bash ACI
./5min_data.bash ADBE
./5min_data.bash AEM
./5min_data.bash AFL
./5min_data.bash AGU
./5min_data.bash AIG
./5min_data.bash AKAM
./5min_data.bash ALL
./5min_data.bash AMGN
./5min_data.bash AMT
./5min_data.bash AMX
./5min_data.bash AMZN
./5min_data.bash APA
./5min_data.bash APC
./5min_data.bash ARG
./5min_data.bash AXP
./5min_data.bash AXU
./5min_data.bash BA
./5min_data.bash BBT
./5min_data.bash BBY
./5min_data.bash BEN
./5min_data.bash BHP
./5min_data.bash BIDU
./5min_data.bash BP
./5min_data.bash BRCM
./5min_data.bash BTU
./5min_data.bash BUCY
./5min_data.bash CAT
./5min_data.bash CDE
./5min_data.bash CELG
./5min_data.bash CEO
./5min_data.bash CHK
./5min_data.bash CLF
./5min_data.bash CMI
./5min_data.bash COF
./5min_data.bash COP
./5min_data.bash COST
./5min_data.bash CREE
./5min_data.bash CRM
./5min_data.bash CSX
./5min_data.bash CTSH
./5min_data.bash CVE
./5min_data.bash CVS
./5min_data.bash CVX
./5min_data.bash DD
./5min_data.bash DE
./5min_data.bash DIA
./5min_data.bash DIS
./5min_data.bash DNDN
./5min_data.bash DTV
./5min_data.bash DVN
./5min_data.bash EBAY
./5min_data.bash EFA
./5min_data.bash EOG
./5min_data.bash ESRX
./5min_data.bash EWZ
./5min_data.bash EXK
./5min_data.bash FCX
./5min_data.bash FDX
./5min_data.bash FFIV
./5min_data.bash FLS
./5min_data.bash FSLR
./5min_data.bash FXI
./5min_data.bash GD
./5min_data.bash GDX
./5min_data.bash GFI
./5min_data.bash GG
./5min_data.bash GILD
./5min_data.bash GLD
./5min_data.bash GOOG
./5min_data.bash GS
./5min_data.bash HAL
./5min_data.bash HD
./5min_data.bash HES
./5min_data.bash HL
./5min_data.bash HOC
./5min_data.bash HON
./5min_data.bash HPQ

# Get a backup:
./expdp_ibs5min.bash > /pt/s/cron/out/expdp_ibs5min.${myts}.ibs.txt 2>&1

# Merge IB data with Dukas data:
sqt>update_di5min_stk.txt<<EOF
@update_di5min_stk.sql
EOF

./expdp_di5.bash > /pt/s/cron/out/expdp_di5.${myts}.ibs.txt 2>&1

exit
