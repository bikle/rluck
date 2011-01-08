#!/bin/bash

# 5min_data.bash

# I use this script to download prices spread 5 min apart for TKR.

# Demo:
# 5min_data.bash SPY

if [ $# -eq 1 ]
then

. /pt/s/rluck/svmspy/.jruby
. /pt/s/rluck/svmspy/.orcl

set -x

cd /pt/s/rluck/svmspy/ibapi/

jruby req_hdata_1D.rb $1

export myts=`date +%Y_%m_%d_%H_%M`
# Now I load the data into table, ibs5min:

./load5min.bash $1 > /pt/s/cron/out/load5min.${myts}.ibs.txt 2>&1

# Get a backup.
./expdp_ibs5min.bash > /pt/s/cron/out/expdp_ibs5min.${myts}.ibs.txt 2>&1

else
  echo You need to give a tkr.
  echo Demo:
  echo $0 SPY
  exit 1
fi


exit 0
./rm_old_csv.bash  > /pt/s/cron/out/rm_old_csv.${myts}.txt 2>&1

