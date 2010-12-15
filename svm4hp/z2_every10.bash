#!/bin/bash

# z2_every10.bash

# I run this script frequently, perhaps every 10 minutes.

. /pt/s/rluck/svm4hp/.orcl
. /pt/s/rluck/svm4hp/.jruby

set -x 
cd $SVM4HP

export myts=`date +%Y_%m_%d_%H_%M`

# I need a table:
sqt>/pt/s/cron/out/update_di5min.${myts}.txt<<EOF
@update_di5min.sql
EOF

# Next I create some scripts and then run SVM:
./run_svm4hp.bash > /pt/s/cron/out/svm4hp.${myts}.txt 2>&1

exit
