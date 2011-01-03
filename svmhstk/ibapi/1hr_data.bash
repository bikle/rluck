#!/bin/bash

# 1hr_data.bash

# I use this script to download prices spread 1hr apart for TKR.

# Demo:
# 1hr_data.bash SPY

if [ $# -eq 1 ]
then

. /pt/s/rluck/svmhstk/.jruby
. /pt/s/rluck/svmhstk/.orcl

set -x

cd $SVMHSTK/ibapi

jruby req_hdata_1D.rb $1

exit

export myts=`date +%Y_%m_%d_%H_%M`
# Now I load the data into table, ibs1hr:

./load1hr.bash $1 > /pt/s/cron/out/load1hr.${myts}.ibs.txt 2>&1

else
  echo You need to give a tkr.
  echo Demo:
  echo $0 SPY
  exit 1
fi


exit

export myts=`date +%Y_%m_%d_%H_%M`
# Now I load the data into table, ibf1hr:
./load1hr.bash $1 > /pt/s/cron/out/load1hr.${myts}.txt 2>&1

# Look at data in ibf1hr

sqt>qry_ibf1hr.txt<<EOF
@qry_ibf1hr.sql
EOF
cp -p qry_ibf1hr.txt /pt/s/cron/out/qry_ibf1hr.${myts}.txt

# Get a backup
./expdp1hr.bash  > /pt/s/cron/out/expdp1hr.${myts}.txt 2>&1

# rm old csv files
./rm_old_csv.bash  > /pt/s/cron/out/rm_old_csv.${myts}.txt 2>&1

exit
