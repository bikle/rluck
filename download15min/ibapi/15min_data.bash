#!/bin/bash

# 15min_data.bash

# I use this script to download prices spread 15 min apart for TKR.

# Demo:
# 15min_data.bash SPY

if [ $# -eq 1 ]
then

. /pt/s/rluck/dl15/.jruby
. /pt/s/rluck/dl15/.orcl

set -x

cd /pt/s/rluck/dl15/ibapi/

jruby req_hdata.rb $1

export myts=`date +%Y_%m_%d_%H_%M`
# Now I load the data into table, ibs15min:

./load15min.bash $1 > /pt/s/cron/out/load15min.${myts}.ibs.txt 2>&1

# Get a backup.
./expdp_ibs15min.bash > /pt/s/cron/out/expdp_ibs15min.${myts}.ibs.txt 2>&1

else
  echo You need to give a tkr.
  echo Demo:
  echo $0 SPY
  exit 1
fi


exit 0
# ./rm_old_csv.bash  > /pt/s/cron/out/rm_old_csv.${myts}.txt 2>&1

