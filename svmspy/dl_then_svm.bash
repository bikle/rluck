#!/bin/bash

# dl_then_svm.bash

# I use this script to do these things:
# - Download price data from IB and load it into DB.
# - Run SVM against the new data.
# - Report on the new SVM scroes.


if [ $# -ne 1 ]
then
  echo You need to give a tkr.
  echo Demo:
  echo $0 SPY
  exit 1
else

. /pt/s/rluck/svmspy/.orcl
. /pt/s/rluck/svmspy/.jruby

set -x

date

cd $SVMSPY/ibapi
./5min_data.bash $1

# Merge IB data with Dukas data:
sqt>update_di5min_stk.txt<<EOF
@update_di5min_stk.sql
EOF

cd $SVMSPY

## I need to enhance this ./svmtkr.bash $1

# end of if [ $# -ne 1 ] #######
fi
# end of if [ $# -ne 1 ] #######

exit 0
