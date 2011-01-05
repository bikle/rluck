#!/bin/bash

# dl_then_svm.bash

# I use this script to do these things:
# - Download price data from IB and load it into DB.
# - Run SVM against the new data.
# - Report on the new SVM scores.


if [ $# -ne 1 ]
then
  echo You need to give a tkr.
  echo Demo:
  echo $0 SPY
  exit 1
else

. /pt/s/rluck/svmhstk/.orcl
. /pt/s/rluck/svmhstk/.jruby

set -x

date

cd $SVMHSTK/ibapi
## ./5min_data.bash $1
./1hr_data.bash $1

exit

# Merge IB data with Dukas data:
sqt>update_di1hr_stk.txt<<EOF
@update_di1hr_stk.sql
EOF

cd $SVMHSTK

./svmtkr.bash $1

# end of if [ $# -ne 1 ] #######
fi
# end of if [ $# -ne 1 ] #######

exit 0
