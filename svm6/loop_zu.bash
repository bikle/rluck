#!/bin/bash

# loop_zu.bash

# I call this script from loop_til_sat.bash

# It allows me to change what loop_til_sat.bash does without stopping it.

# I run this script frequently, perhaps every 10 minutes.

. /pt/s/rluck/svm6/.orcl
. /pt/s/rluck/svm6/.jruby

set -x 
export myts=`date +%Y_%m_%d_%H_%M`

cd $SVM6
cd ibapi
# I need a table:
./run5min_data.bash > /pt/s/cron/out/run5min_data.${myts}.txt 2>&1
sqt>/pt/s/cron/out/update_di5min.${myts}.txt<<EOF
@update_di5min.sql
EOF

cd $SVM6
cd svm/
# Now I generate some scripts from some templates:
jruby sedem.rb

# Now, for each pair, I create some tables full of model attributes:
# aud_ms610, aud_att, ... , chf_ms610, chf_att
./bld_run_big610.bash > /pt/s/cron/out/bld_run_big610.${myts}.txt 2>&1
chmod +x *bash

# Now, for each pair, run SVM, collect scores, and act on the scores:

#aud
./ech_svm.bash > /pt/s/cron/out/aud_svm.${myts}.txt 2>&1
