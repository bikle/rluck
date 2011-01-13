#!/bin/bash

. /pt/s/rluck/svmspy/.orcl
. /pt/s/rluck/svmspy/.jruby

set -x

date

cd $SVMSPY

./dl_then_svm.bash DIA	
./dl_then_svm.bash DIS	
./dl_then_svm.bash EBAY	
./dl_then_svm.bash GOOG	
./dl_then_svm.bash HPQ	
./dl_then_svm.bash IBM	
./dl_then_svm.bash QQQQ	
./dl_then_svm.bash SPY	
./dl_then_svm.bash WMT	
./dl_then_svm.bash X	
./dl_then_svm.bash XOM	


exit 0
