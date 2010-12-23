#!/bin/bash

# oc.bash

# I use this script to help me execute open/close orders.
# Here I populate the oc table which is later acted upon by xoc.bash

# Demo:
# ./oc.bash aud

. /pt/s/rluck/svm8hp/.orcl
. /pt/s/rluck/svm8hp/.jruby

set -x 
cd $SVM8HP
cd openclose/

export myts=`date +%Y_%m_%d_%H_%M`
jruby oc.rb $1 > /pt/s/cron/out/oc.rb.${myts}.txt 2>&1
mv oc_sql_spool.txt oc_sql_spool.${myts}.txt

# Now, xoc.bash will act on entries in the oc table.
## ./xoc.bash > /pt/s/cron/out/xoc.bash.${myts}.txt 2>&1

exit

