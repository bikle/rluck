#!/bin/bash

. /pt/s/rluck/svmspy/.orcl
. /pt/s/rluck/svmspy/.jruby

set -x

date

cd $SVMSPY

./svmtkr.bash  T      
./svmtkr.bash  COF    
./svmtkr.bash  CVE    
./svmtkr.bash  TKR    

./svmtkr.bash  DTV    
./svmtkr.bash  UNP    
./svmtkr.bash  V      

./svmtkr.bash  UPS    
./svmtkr.bash  EXK    
./svmtkr.bash  FFIV   

exit

./svmtkr.bash  VECO   
./svmtkr.bash  WDC    
./svmtkr.bash  GFI    
./svmtkr.bash  VMW    

./svmtkr.bash  WFMI   
./svmtkr.bash  WHR    
./svmtkr.bash  WMT    

./svmtkr.bash  IOC    
./svmtkr.bash  XLU    
./svmtkr.bash  MJN    

