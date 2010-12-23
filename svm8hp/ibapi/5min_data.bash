#!/bin/bash

# 5min_data.bash

# I use this script to download prices spread 5 min apart for 6 pairs.

. /pt/s/rluck/svm8hp/.jruby
. /pt/s/rluck/svm8hp/.orcl

set -x

cd /pt/s/rluck/svm8hp/ibapi/

jruby req_hdata_1D.rb AUD USD
jruby req_hdata_1D.rb EUR USD
jruby req_hdata_1D.rb GBP USD

jruby req_hdata_1D.rb USD CAD
jruby req_hdata_1D.rb USD CHF
jruby req_hdata_1D.rb USD JPY

export myts=`date +%Y_%m_%d_%H_%M`
# Now I load the data into table, ibf5min:
./load5min.bash > /pt/s/cron/out/load5min.${myts}.txt 2>&1

exit

# Look at data in ibf5min

sqt>qry_ibf5min.txt<<EOF
@qry_ibf5min.sql
EOF
cp -p qry_ibf5min.txt /pt/s/cron/out/qry_ibf5min.${myts}.txt

# Get a backup
./expdp5min.bash

# rm old csv files
./rm_old_csv.bash

exit
