#!/bin/bash

# loop_once.bash

# I call this script from loop_til_sat.bash

# It allows me to change what loop_til_sat.bash does without stopping it.

# I run this script frequently, perhaps every 10 minutes.

. /pt/s/rluck/svm4/.orcl
. /pt/s/rluck/svm4/.jruby

set -x 

cd $SVM4
export myts=`date +%Y_%m_%d_%H_%M`
cd svm/
# Now I generate some scripts from some templates:
jruby sedem.rb

# Now, for each pair, I create some tables full of model attributes:
# aud_ms410, aud_att, ... , chf_ms410, chf_att
./bld_run_big410.bash > /pt/s/cron/out/bld_run_big410.${myts}.txt 2>&1

# Now, for each pair, run SVM and collect the scores:
chmod +x *bash
./aud_svm.bash > /pt/s/cron/out/aud_svm.${myts}.txt 2>&1
