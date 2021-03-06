#!/bin/bash

# oc.bash

# I use this script to help me execute open/close orders.
# Here I populate the oc table which is later acted upon by xoc.bash

. /pt/s/rluck/svm4hp/.orcl
. /pt/s/rluck/svm4hp/.jruby

set -x 
cd $SVM4HP
cd openclose/

sqt>oc.txt<<EOF
@oc.sql
EOF

export myts=`date +%Y_%m_%d_%H_%M`
cp -p oc.txt /pt/s/cron/out/oc.${myts}.txt

# Now, xoc.bash will act on entries in the oc table.
./xoc.bash > /pt/s/cron/out/xoc.bash.${myts}.txt 2>&1

exit

