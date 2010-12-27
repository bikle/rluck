#!/bin/bash

# oc.bash

# I use this script to help me execute open/close orders.
# Here I populate the oc table which is later acted upon by xoc.bash

# Demo:
# ./oc.bash aud

. /pt/s/rluck/svm6/.orcl
. /pt/s/rluck/svm6/.jruby

set -x 
cd $SVM6
cd openclose/

export myts=`date +%Y_%m_%d_%H_%M`
jruby oc.rb $1 > /pt/s/cron/out/oc.rb.${myts}.${1}.txt 2>&1
cp oc_sql_spool.txt /pt/s/cron/out/oc_sql_spool.${myts}.${1}.txt

# Now, xoc.bash will act on entries in the oc table.
./xoc.bash > /pt/s/cron/out/xoc.bash.${myts}.txt 2>&1

sqt>qry_oc.${1}.txt<<EOF
@qry_oc.sql
EOF

cp -p qry_oc.${1}.txt /pt/s/cron/out/qry_oc.${myts}.${1}.txt

exit

