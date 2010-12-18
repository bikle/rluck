#!/bin/bash

# backtest.bash

# I run this script to backtest my SVM-8-hr-holding-period strategy

. /pt/s/rluck/svm8hp/.orcl
. /pt/s/rluck/svm8hp/.jruby

set -x 

cd $SVM8HP
export myts=`date +%Y_%m_%d_%H_%M`
# I need a table.
# Currently I get latest data via:
# /pt/s/api/f/5min_data/run5min_data.bash
sqt>/pt/s/cron/out/update_di5min.${myts}.txt<<EOF
@update_di5min.sql
EOF

cd svm2/

# Now I generate some scripts from some templates:
jruby sedem.rb

exit

# Now, for each pair, I create some tables full of model attributes:
# aud_ms10, aud_att, ... , chf_ms10, chf_att
./bld_run_big10.bash > /pt/s/cron/out/bld_run_big10.${myts}.txt 2>&1
# Now, for each pair, run SVM and collect the scores:
chmod +x *bash
./aud_svm2.bash > /pt/s/cron/out/aud_svm2.${myts}.txt 2>&1

# Now do eur_usd:

exit
exit
