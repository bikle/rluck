#!/bin/bash

# loop_once.bash

# I use this script to wrap dl_then_svm.bash for loop_til_sat.bash
# So, this script is called by loop_til_sat.bash

. /pt/s/rluck/svmspy/.orcl
. /pt/s/rluck/svmspy/.jruby

set -x

date

cd $SVMSPY

./dl_then_svm.bash MJN
exit
./dl_then_svm.bash AAPL
./dl_then_svm.bash ABT
./dl_then_svm.bash ABX
./dl_then_svm.bash ADBE
./dl_then_svm.bash AEM
./dl_then_svm.bash AFL
./dl_then_svm.bash AIG
./dl_then_svm.bash AKAM
./dl_then_svm.bash ALL
./dl_then_svm.bash AMGN
./dl_then_svm.bash AMT
./dl_then_svm.bash AMX
./dl_then_svm.bash AMZN
./dl_then_svm.bash APA
./dl_then_svm.bash APC
./dl_then_svm.bash ARG
./dl_then_svm.bash AXP
./dl_then_svm.bash BA
./dl_then_svm.bash BBT
./dl_then_svm.bash BBY
./dl_then_svm.bash BEN
./dl_then_svm.bash BHP
./dl_then_svm.bash BIDU
./dl_then_svm.bash BP
./dl_then_svm.bash BRCM
./dl_then_svm.bash BTU
./dl_then_svm.bash BUCY
./dl_then_svm.bash CAT
./dl_then_svm.bash CELG
./dl_then_svm.bash CLF
./dl_then_svm.bash CMI
./dl_then_svm.bash COF
./dl_then_svm.bash COP
./dl_then_svm.bash COST
./dl_then_svm.bash CREE
./dl_then_svm.bash CRM
./dl_then_svm.bash CSX
./dl_then_svm.bash CTSH
./dl_then_svm.bash CVS
./dl_then_svm.bash CVX
./dl_then_svm.bash DD
./dl_then_svm.bash DE
./dl_then_svm.bash DIA
./dl_then_svm.bash DIS
./dl_then_svm.bash DNDN
./dl_then_svm.bash DTV
./dl_then_svm.bash DVN
./dl_then_svm.bash EFA
./dl_then_svm.bash EOG
./dl_then_svm.bash ESRX
./dl_then_svm.bash EWZ
./dl_then_svm.bash FCX
./dl_then_svm.bash FDX
./dl_then_svm.bash FFIV
./dl_then_svm.bash FLS
./dl_then_svm.bash FSLR
./dl_then_svm.bash GDX
./dl_then_svm.bash GG
./dl_then_svm.bash GILD
./dl_then_svm.bash GLD
./dl_then_svm.bash GOOG
./dl_then_svm.bash GS
./dl_then_svm.bash HD
./dl_then_svm.bash HES
./dl_then_svm.bash HON
./dl_then_svm.bash HPQ
./dl_then_svm.bash IBM
./dl_then_svm.bash IOC
./dl_then_svm.bash IWM
./dl_then_svm.bash JNJ
./dl_then_svm.bash JOYG
./dl_then_svm.bash JPM
./dl_then_svm.bash JWN
./dl_then_svm.bash KO
./dl_then_svm.bash LFT
./dl_then_svm.bash MAR
./dl_then_svm.bash MCD
./dl_then_svm.bash MDT
./dl_then_svm.bash MDY
./dl_then_svm.bash MEE
./dl_then_svm.bash MET

./dl_then_svm.bash MMM
./dl_then_svm.bash MON
./dl_then_svm.bash MOS
./dl_then_svm.bash MRK
./dl_then_svm.bash MT
./dl_then_svm.bash NEM
./dl_then_svm.bash NFLX
./dl_then_svm.bash NUE
./dl_then_svm.bash OIH
./dl_then_svm.bash OXY
./dl_then_svm.bash PBR
./dl_then_svm.bash PEP
./dl_then_svm.bash PG
./dl_then_svm.bash PM
./dl_then_svm.bash PNC
./dl_then_svm.bash POT
./dl_then_svm.bash PRU
./dl_then_svm.bash QCOM
./dl_then_svm.bash QQQQ
./dl_then_svm.bash RIG
./dl_then_svm.bash RIMM
./dl_then_svm.bash SINA
./dl_then_svm.bash SJM
./dl_then_svm.bash SKX
./dl_then_svm.bash SLB
./dl_then_svm.bash SLV
./dl_then_svm.bash SNDK
./dl_then_svm.bash SPY
./dl_then_svm.bash STT
./dl_then_svm.bash SUN
./dl_then_svm.bash TEVA
./dl_then_svm.bash TGT
./dl_then_svm.bash TKR
./dl_then_svm.bash TLT
./dl_then_svm.bash UNH
./dl_then_svm.bash UNP
./dl_then_svm.bash UPS
./dl_then_svm.bash V
./dl_then_svm.bash VECO
./dl_then_svm.bash VMW
./dl_then_svm.bash WDC
./dl_then_svm.bash WFMI
./dl_then_svm.bash WHR
./dl_then_svm.bash WMT
./dl_then_svm.bash WYNN
./dl_then_svm.bash X
./dl_then_svm.bash XLB
./dl_then_svm.bash XLE
./dl_then_svm.bash XLU
./dl_then_svm.bash XOM


exit 0
