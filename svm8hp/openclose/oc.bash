#!/bin/bash

# oc.bash

# I use this script to help me execute open/close orders.
# Here I populate the oc table which is later acted upon by xoc.bash

. /pt/s/rluck/svm8hp/.orcl
. /pt/s/rluck/svm8hp/.jruby

set -x 
cd $SVM8HP
cd openclose/

# Get the latest pair which has been scored:
sqt>latest_pair.txt<<EOF
@latest_pair.sql
EOF

export latest_pair=`grep llatest_pair latest_pair.txt|grep 1|grep -v SELECT|awk '{print $2}'`

sqt>oc.txt<<EOF
@oc.sql $latest_pair
EOF

export myts=`date +%Y_%m_%d_%H_%M`
cp -p oc.txt /pt/s/cron/out/oc.${myts}.txt

# Now, xoc.bash will act on entries in the oc table.
./xoc.bash > /pt/s/cron/out/xoc.bash.${myts}.txt 2>&1

exit

