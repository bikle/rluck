#!/bin/bash

# z2_4after.bash

# I run this 4 min after the hour via cron usually.

. /pt/s/oracle/.orcl
. /pt/s/oracle/.jruby

set -x 
cd $SVM4HP

export myts=`date +%Y_%m_%d_%H_%M`

# I need a table:
sqt>/pt/s/cron/out/update_ibfu_t.${myts}.txt<<EOF
@update_ibfu_t.sql
EOF

# Next I create some scripts and then run SVM:
./svm4hp.bash > /pt/s/cron/out/svm4hp.${myts}.txt 2>&1

exit
