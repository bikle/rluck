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
./load5min.bash $1

cd $SVMSPY
# Not quite yet.
# svmtkr.bash is currently occupied by a backtest:
echo ./svmtkr.bash $1

# end of if [ $# -ne 1 ] #######
fi
# end of if [ $# -ne 1 ] #######

exit 0
