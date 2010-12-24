#!/bin/bash

# loop_once.bash

# I call this script from loop_til_sat.bash

# It allows me to change what loop_til_sat.bash does without stopping it.

# I run this script frequently, perhaps every 10 minutes.

. /pt/s/rluck/svm6/.orcl
. /pt/s/rluck/svm6/.jruby

set -x 

cd $SVM6
export myts=`date +%Y_%m_%d_%H_%M`
cd svm2/
# Now I generate some scripts from some templates:
jruby sedem.rb
# Now, for each pair, I create some tables full of model attributes:
# aud_ms10, aud_att, ... , chf_ms10, chf_att
./bld_run_big10.bash > /pt/s/cron/out/bld_run_big10.${myts}.txt 2>&1
# Now, for each pair, run SVM and collect the scores:
chmod +x *bash
./aud_svm2.bash > /pt/s/cron/out/aud_svm2.${myts}.txt 2>&1
