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
  echo $0 aud_usd
  exit 1
else

. /pt/s/rluck/svm62/.orcl
. /pt/s/rluck/svm62/.jruby

set -x

date

cd $SVM62/ibapi
./5min_data.bash

# Merge IB data with Dukas data:
sqt>update_di5min.txt<<EOF
@update_di5min.sql
EOF

cd $SVM62

./svmpair.bash $1

# end of if [ $# -ne 1 ] #######
fi
# end of if [ $# -ne 1 ] #######

exit 0
