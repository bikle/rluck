#!/bin/bash

# z2_4after.bash

# run this 4 min after the hour

. /pt/s/oracle/.orcl
. /pt/s/oracle/.jruby

set -x 
cd /pt/s/rlk/svm4hp/
export myts=`date +%Y_%m_%d_%H_%M`

# I need a table:
sqt>/pt/s/cron/out/update_ibfu_t.${myts}.txt<<EOF
@update_ibfu_t.sql
EOF
