#!/bin/bash

# run_svm4hp.bash

# I use this script as an entry point into a backtest of the svm4hp strategy.

. /pt/s/rluck/svm4hp/.orcl
. /pt/s/rluck/svm4hp/.jruby

set -x
cd $SVM4HP
cd svm2/

export myts=`date +%Y_%m_%d_%H_%M`

# Now I generate some scripts from some templates:
jruby sedem.rb

# Now, for each pair, I create some tables full of model attributes:
# aud_ms10, aud_att, ... , chf_ms10, chf_att
./bld_run_big10.bash > /pt/s/cron/out/bld_run_big10.${myts}.txt 2>&1
exit

# Now, for each pair, run SVM and collect the scores:
chmod +x *bash
./aud_svm2.bash > /pt/s/cron/out/aud_svm2.${myts}.txt 2>&1

