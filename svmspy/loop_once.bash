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
./dl_then_svm.bash  HL    

./dl_then_svm.bash  VALE  
./dl_then_svm.bash  SOHU  
./dl_then_svm.bash  PALL  
./dl_then_svm.bash  PAAS  
./dl_then_svm.bash  AGU   
./dl_then_svm.bash  SCCO  
./dl_then_svm.bash  EXK   
./dl_then_svm.bash  AMT   
./dl_then_svm.bash  CHK   
./dl_then_svm.bash  ARG   
./dl_then_svm.bash  QQQQ  
./dl_then_svm.bash  ABT   
./dl_then_svm.bash  AEM   
./dl_then_svm.bash  MET   
./dl_then_svm.bash  SLW   
./dl_then_svm.bash  PEP   
./dl_then_svm.bash  XLU   
./dl_then_svm.bash  MDT   
./dl_then_svm.bash  WDC   
./dl_then_svm.bash  GS    
./dl_then_svm.bash  BRCM  
./dl_then_svm.bash  SKX   
./dl_then_svm.bash  OIH   
./dl_then_svm.bash  HON   
./dl_then_svm.bash  FDX   
./dl_then_svm.bash  OXY   
./dl_then_svm.bash  CVX   
./dl_then_svm.bash  BBT   
./dl_then_svm.bash  JWN   
./dl_then_svm.bash  CAT   
./dl_then_svm.bash  XLE   
./dl_then_svm.bash  BBY   
./dl_then_svm.bash  SNDK  
./dl_then_svm.bash  AAPL  
./dl_then_svm.bash  ALL   
./dl_then_svm.bash  SVM   
./dl_then_svm.bash  SPY   
./dl_then_svm.bash  VECO  
./dl_then_svm.bash  MT    
./dl_then_svm.bash  BHP   
./dl_then_svm.bash  AXP   
./dl_then_svm.bash  BA    
./dl_then_svm.bash  AIG   
./dl_then_svm.bash  AMGN  
./dl_then_svm.bash  AFL   
./dl_then_svm.bash  DD    
./dl_then_svm.bash  DIA   
./dl_then_svm.bash  MAR   
./dl_then_svm.bash  STT   
./dl_then_svm.bash  MRK   

exit 0
