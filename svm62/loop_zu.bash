#!/bin/bash

# loop_zu.bash

# I call this script from loop_til_sat.bash

# It allows me to change what loop_til_sat.bash does without stopping it.

# I run this script frequently, perhaps every 10 minutes.

. /pt/s/rluck/svm62/.orcl
. /pt/s/rluck/svm62/.jruby

set -x 
export myts=`date +%Y_%m_%d_%H_%M`

cd $SVM62

./extra.bash > /pt/s/cron/out/extra_bash.${myts}.txt 2>&1

./dl_then_svm.bash aud_usd > /pt/s/cron/out/dl_then_svm_aud_usd.${myts}.txt 2>&1

sleep 3

exit 0


