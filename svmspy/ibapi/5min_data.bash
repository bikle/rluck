#!/bin/bash

# 5min_data.bash

# I use this script to download prices spread 5 min apart for SPY.

. /pt/s/rluck/svmspy/.jruby
. /pt/s/rluck/svmspy/.orcl

set -x

cd /pt/s/rluck/svmspy/ibapi/

jruby --debug req_hdata_1D.rb SPY

exit

export myts=`date +%Y_%m_%d_%H_%M`
# Now I load the data into table, ibf5min:
./load5min.bash > /pt/s/cron/out/load5min.${myts}.txt 2>&1

# Look at data in ibf5min

sqt>qry_ibf5min.txt<<EOF
@qry_ibf5min.sql
EOF
cp -p qry_ibf5min.txt /pt/s/cron/out/qry_ibf5min.${myts}.txt

# Get a backup
./expdp5min.bash  > /pt/s/cron/out/expdp5min.${myts}.txt 2>&1

# rm old csv files
./rm_old_csv.bash  > /pt/s/cron/out/rm_old_csv.${myts}.txt 2>&1

exit
