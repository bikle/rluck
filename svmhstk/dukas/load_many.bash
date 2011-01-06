#!/bin/bash

# load_many.bash

# I use this script to wrap ./load_tkr_1hr.bash

. /pt/s/rluck/svmhstk/.orcl
. /pt/s/rluck/svmhstk/.jruby

set -x

cd $SVMHSTK/dukas/

./load_tkr_1hr.bash DIA
./load_tkr_1hr.bash DIS 
./load_tkr_1hr.bash EBAY
./load_tkr_1hr.bash GOOG
./load_tkr_1hr.bash HPQ 
./load_tkr_1hr.bash IBM 
./load_tkr_1hr.bash QQQQ
./load_tkr_1hr.bash SPY
./load_tkr_1hr.bash WMT 
./load_tkr_1hr.bash XOM 

exit 0
