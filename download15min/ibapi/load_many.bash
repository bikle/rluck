#!/bin/bash

# load_many.bash

. /pt/s/rluck/dl15/.orcl
. /pt/s/rluck/dl15/.jruby

cd /pt/s/rluck/dl15/ibapi/

date

# I keep a list of tkrs I like here:
# list_of_tkrs.txt

# Get a backup.
echo I am running an export b4 starting.
./expdp_ibs15min.bash > /pt/s/cron/out/expdp_ibs15min.${myts}.ibs.txt 2>&1

date

./15min_data.bash SWC
./15min_data.bash AAPL
./15min_data.bash ABT
./15min_data.bash ABX
./15min_data.bash ADBE
./15min_data.bash AEM
./15min_data.bash AFL
./15min_data.bash AIG
./15min_data.bash AKAM
./15min_data.bash ALL
./15min_data.bash AMGN
./15min_data.bash AMT
./15min_data.bash AMX
./15min_data.bash AMZN
./15min_data.bash APA
./15min_data.bash APC
./15min_data.bash ARG
./15min_data.bash AXP
./15min_data.bash BA
./15min_data.bash BBT
./15min_data.bash BBY
./15min_data.bash BEN
./15min_data.bash BHP
./15min_data.bash BIDU
./15min_data.bash BP
./15min_data.bash BRCM
./15min_data.bash BTU
./15min_data.bash BUCY
./15min_data.bash CAT
./15min_data.bash CELG
./15min_data.bash CLF
./15min_data.bash CMI
./15min_data.bash COF
./15min_data.bash COP
./15min_data.bash COST
./15min_data.bash CREE
./15min_data.bash CRM
./15min_data.bash CSX
./15min_data.bash CTSH
./15min_data.bash CVS
./15min_data.bash CVX
./15min_data.bash DD
./15min_data.bash DE
./15min_data.bash DIA
./15min_data.bash DIS
./15min_data.bash DNDN
./15min_data.bash DTV
./15min_data.bash DVN
./15min_data.bash EFA
./15min_data.bash EOG
./15min_data.bash ESRX
./15min_data.bash EWZ
./15min_data.bash FCX
./15min_data.bash FDX
./15min_data.bash FFIV
./15min_data.bash FLS
./15min_data.bash FSLR
./15min_data.bash GDX
./15min_data.bash GG
./15min_data.bash GILD
./15min_data.bash GLD
./15min_data.bash GOOG
./15min_data.bash GS
./15min_data.bash HD
./15min_data.bash HES
./15min_data.bash HON
./15min_data.bash HPQ
./15min_data.bash IBM
./15min_data.bash IOC
./15min_data.bash IWM
./15min_data.bash JNJ
./15min_data.bash JOYG
./15min_data.bash JPM
./15min_data.bash JWN
./15min_data.bash KO
./15min_data.bash LFT
./15min_data.bash MAR
./15min_data.bash MCD
./15min_data.bash MDT
./15min_data.bash MDY
./15min_data.bash MEE
./15min_data.bash MET
./15min_data.bash MJN
./15min_data.bash MMM
./15min_data.bash MON
./15min_data.bash MOS
./15min_data.bash MRK
./15min_data.bash MT
./15min_data.bash NEM
./15min_data.bash NFLX
./15min_data.bash NUE
./15min_data.bash OIH
./15min_data.bash OXY
./15min_data.bash PBR
./15min_data.bash PEP
./15min_data.bash PG
./15min_data.bash PM
./15min_data.bash PNC
./15min_data.bash POT
./15min_data.bash PRU
./15min_data.bash QCOM
./15min_data.bash QQQQ
./15min_data.bash RIG
./15min_data.bash RIMM
./15min_data.bash SINA
./15min_data.bash SJM
./15min_data.bash SKX
./15min_data.bash SLB
./15min_data.bash SLV
./15min_data.bash SNDK
./15min_data.bash SPY
./15min_data.bash STT
./15min_data.bash SUN
./15min_data.bash TEVA
./15min_data.bash TGT
./15min_data.bash TLT
./15min_data.bash UNH
./15min_data.bash UNP
./15min_data.bash UPS
./15min_data.bash V
./15min_data.bash VECO
./15min_data.bash VMW
./15min_data.bash WDC
./15min_data.bash WFMI
./15min_data.bash WHR
./15min_data.bash WMT
./15min_data.bash WYNN
./15min_data.bash X
./15min_data.bash XLB
./15min_data.bash XLE
./15min_data.bash XLU
./15min_data.bash XOM

date

# Get a backup.
./expdp_ibs15min.bash > /pt/s/cron/out/expdp_ibs15min.${myts}.ibs.txt 2>&1

date

exit
