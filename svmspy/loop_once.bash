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

./dl_then_svm.bash SOHU  
./dl_then_svm.bash BBT   
./dl_then_svm.bash DTV   
./dl_then_svm.bash DNDN  
./dl_then_svm.bash BIDU  
./dl_then_svm.bash MEE   
./dl_then_svm.bash ARG   
./dl_then_svm.bash PM    
./dl_then_svm.bash SLV   
./dl_then_svm.bash XOM   
./dl_then_svm.bash MOS   
./dl_then_svm.bash DIA   
./dl_then_svm.bash SPY   
./dl_then_svm.bash CVE   
./dl_then_svm.bash AXP   
./dl_then_svm.bash GDX   
./dl_then_svm.bash DIS   
./dl_then_svm.bash WYNN  
./dl_then_svm.bash FSLR  
./dl_then_svm.bash LMT   
./dl_then_svm.bash HPQ   
./dl_then_svm.bash MAR   
./dl_then_svm.bash VLO   
./dl_then_svm.bash IOC   
./dl_then_svm.bash IBM   
./dl_then_svm.bash JOYG  
./dl_then_svm.bash AIG   
./dl_then_svm.bash AMX   
./dl_then_svm.bash POT   
./dl_then_svm.bash EOG   
./dl_then_svm.bash HL    
./dl_then_svm.bash CVX   
./dl_then_svm.bash ADBE  
./dl_then_svm.bash EFA   
./dl_then_svm.bash PNC   
./dl_then_svm.bash MJN   
./dl_then_svm.bash BUCY  
./dl_then_svm.bash CTSH  
./dl_then_svm.bash PALL  
./dl_then_svm.bash SWC   
./dl_then_svm.bash VMW   
./dl_then_svm.bash MON   
./dl_then_svm.bash MT    
./dl_then_svm.bash AMT   
./dl_then_svm.bash SLW   
./dl_then_svm.bash DVN   
./dl_then_svm.bash XLE   
./dl_then_svm.bash XLU   
./dl_then_svm.bash FCX   
./dl_then_svm.bash BP    
./dl_then_svm.bash AGU   
./dl_then_svm.bash AFL   
./dl_then_svm.bash BHP   
./dl_then_svm.bash TGT   
./dl_then_svm.bash OXY   
./dl_then_svm.bash FLS   
./dl_then_svm.bash COF   
./dl_then_svm.bash ABX   
./dl_then_svm.bash PEP   
./dl_then_svm.bash BEN   
./dl_then_svm.bash TKR   
./dl_then_svm.bash IWM   
./dl_then_svm.bash ORCL  
./dl_then_svm.bash AMZN  
./dl_then_svm.bash DE    
./dl_then_svm.bash HD    
./dl_then_svm.bash PG    

exit 0
