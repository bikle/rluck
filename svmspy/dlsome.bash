#!/bin/bash

. /pt/s/rluck/svmspy/.orcl
. /pt/s/rluck/svmspy/.jruby

set -x

export myts=`date +%Y_%m_%d_%H_%M`

date

cd $SVMSPY/ibapi

./5min_data.bash QQQ
./5min_data.bash SLW
./5min_data.bash SLB

exit

# Get a backup:
./expdp_ibs5min.bash > /pt/s/cron/out/expdp_ibs5min.${myts}.ibs.txt 2>&1

# Merge IB data with Dukas data:
sqt>update_di5min_stk.txt<<EOF
@update_di5min_stk.sql
EOF

./expdp_di5.bash > /pt/s/cron/out/expdp_di5.${myts}.ibs.txt 2>&1
