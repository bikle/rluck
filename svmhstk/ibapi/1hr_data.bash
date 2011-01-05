#!/bin/bash

# 1hr_data.bash

# I use this script to download prices spread 1hr apart for TKR.
# This script is called from here: 
# - /pt/s/rluck/svmhstk/dl_then_svm.bash

# Demo:
# 1hr_data.bash SPY

if [ $# -ne 1 ]
then
  echo You need to give a tkr.
  echo Demo:
  echo $0 SPY
  exit 1
else

. /pt/s/rluck/svmhstk/.jruby
. /pt/s/rluck/svmhstk/.orcl

set -x

cd $SVMHSTK/ibapi

## debug
## debug jruby req_hdata_1D.rb $1
## debug

export myts=`date +%Y_%m_%d_%H_%M`
# Now I load the data into table, ibs1hr:

./load1hr.bash $1 > /pt/s/cron/out/load1hr.${myts}.ibs.txt 2>&1

# end of if ########
fi
# end of if ########

exit 0

###################################
# add this later:

# Look at data in ibs1hr

sqt>qry_ibs1hr.txt<<EOF
@qry_ibs1hr.sql
EOF
cp -p qry_ibs1hr.txt /pt/s/cron/out/qry_ibs1hr.${myts}.txt

# Get a backup
./expdp1hr.bash  > /pt/s/cron/out/expdp1hr.${myts}.txt 2>&1

# rm old csv files
## ./rm_old_csv.bash  > /pt/s/cron/out/rm_old_csv.${myts}.txt 2>&1

exit
