#!/bin/bash

. /pt/s/rluck/svmspy/.orcl
. /pt/s/rluck/svmspy/.jruby

set -x

date

cd $SVMSPY

./dl_then_svm.bash STT   
./dl_then_svm.bash PG    
./dl_then_svm.bash RIMM  
./dl_then_svm.bash VECO  
./dl_then_svm.bash MON   
./dl_then_svm.bash WMT   
./dl_then_svm.bash COF   
./dl_then_svm.bash CSX   
./dl_then_svm.bash DIA   
./dl_then_svm.bash UPS   
./dl_then_svm.bash EWZ   
./dl_then_svm.bash BIDU  
./dl_then_svm.bash TKR   
./dl_then_svm.bash FDX   
./dl_then_svm.bash XLE   
./dl_then_svm.bash TGT   
./dl_then_svm.bash ARG   
./dl_then_svm.bash MET   
./dl_then_svm.bash CTSH  

exit 0
