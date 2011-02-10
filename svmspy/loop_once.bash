#!/bin/bash

# loop_once.bash

# I use this script to wrap dl_then_svm.bash for loop_til_sat.bash
# So, this script is called by loop_til_sat.bash

. /pt/s/rluck/svmspy/.orcl
. /pt/s/rluck/svmspy/.jruby

set -x

date

cd $SVMSPY

# ./svmtkr.bash  HL    
# ./dl_then_svm.bash  HL    

./dl_then_svm.bash FSLR   
./dl_then_svm.bash FFIV   
./dl_then_svm.bash DIA    
./dl_then_svm.bash MT     
./dl_then_svm.bash ARG    
./dl_then_svm.bash DE     
./dl_then_svm.bash PALL   
./dl_then_svm.bash BIDU   
./dl_then_svm.bash MRK    
./dl_then_svm.bash HES    
./dl_then_svm.bash MON    
./dl_then_svm.bash AXP    
./dl_then_svm.bash GFI    
./dl_then_svm.bash GD     
./dl_then_svm.bash MOS    
./dl_then_svm.bash PPLT   
./dl_then_svm.bash GDX    
./dl_then_svm.bash ALL    
./dl_then_svm.bash DIS    
./dl_then_svm.bash EOG    
./dl_then_svm.bash OIH    
./dl_then_svm.bash COST   
./dl_then_svm.bash GILD   
./dl_then_svm.bash WYNN   
./dl_then_svm.bash PEP    
./dl_then_svm.bash CHK    
./dl_then_svm.bash ADBE   
./dl_then_svm.bash V      
./dl_then_svm.bash X      
./dl_then_svm.bash IBM    
./dl_then_svm.bash EFA    
./dl_then_svm.bash AMZN   
./dl_then_svm.bash LFT    
./dl_then_svm.bash FCX    
./dl_then_svm.bash KO     
./dl_then_svm.bash STT    
./dl_then_svm.bash CRM    
./dl_then_svm.bash JNJ    
./dl_then_svm.bash RIMM   
./dl_then_svm.bash BP     
./dl_then_svm.bash HD     
./dl_then_svm.bash NEM    
./dl_then_svm.bash PNC    
./dl_then_svm.bash DD     
./dl_then_svm.bash AKAM   
./dl_then_svm.bash WDC    
./dl_then_svm.bash APC    
./dl_then_svm.bash RDY    
./dl_then_svm.bash FDX    
./dl_then_svm.bash EBAY   
./dl_then_svm.bash MET    
./dl_then_svm.bash BTU    
./dl_then_svm.bash BBY    
./dl_then_svm.bash SPY    
./dl_then_svm.bash FLS    
./dl_then_svm.bash CELG   
./dl_then_svm.bash AMX    
./dl_then_svm.bash PAAS   
./dl_then_svm.bash PBR    
./dl_then_svm.bash QQQQ   
./dl_then_svm.bash BRCM   
./dl_then_svm.bash BHP    
./dl_then_svm.bash VALE   
./dl_then_svm.bash AMGN   
./dl_then_svm.bash UPS    
./dl_then_svm.bash HON    
./dl_then_svm.bash XLB    
./dl_then_svm.bash VECO   
./dl_then_svm.bash JWN    
./dl_then_svm.bash CREE   
./dl_then_svm.bash SVM    
./dl_then_svm.bash SCCO   
./dl_then_svm.bash CTSH   
./dl_then_svm.bash XLU    
./dl_then_svm.bash AGU    
./dl_then_svm.bash APA    
./dl_then_svm.bash BBT    
./dl_then_svm.bash DTV    
./dl_then_svm.bash SLW    
./dl_then_svm.bash HPQ    
./dl_then_svm.bash MAR    
./dl_then_svm.bash CDE    
./dl_then_svm.bash MEE    

exit 0
