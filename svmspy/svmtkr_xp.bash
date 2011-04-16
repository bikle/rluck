#!/bin/bash

set -x

./svmtkr.bash  DTV    
./svmtkr.bash  UNP    
./svmtkr.bash  V      
./svmtkr.bash  UPS    

exit

./svmtkr.bash  WDC    
./svmtkr.bash  GFI    
./svmtkr.bash  VMW    
./svmtkr.bash  WFMI   
./svmtkr.bash  WHR    

