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
./svmpair.bash eur_usd > /pt/s/cron/out/svm_bash_eur_usd.${myts}.txt 2>&1
./svmpair.bash gbp_usd > /pt/s/cron/out/svm_bash_gbp_usd.${myts}.txt 2>&1

./svmpair.bash usd_cad > /pt/s/cron/out/svm_bash_cad_usd.${myts}.txt 2>&1
./svmpair.bash usd_chf > /pt/s/cron/out/svm_bash_chf_usd.${myts}.txt 2>&1
./svmpair.bash usd_jpy > /pt/s/cron/out/svm_bash_jpy_usd.${myts}.txt 2>&1

./svmpair.bash ech_usd > /pt/s/cron/out/svm_bash_ech_usd.${myts}.txt 2>&1
./svmpair.bash egb_usd > /pt/s/cron/out/svm_bash_egb_usd.${myts}.txt 2>&1
./svmpair.bash eau_usd > /pt/s/cron/out/svm_bash_eau_usd.${myts}.txt 2>&1
./svmpair.bash ejp_usd > /pt/s/cron/out/svm_bash_ejp_usd.${myts}.txt 2>&1
./svmpair.bash ajp_usd > /pt/s/cron/out/svm_bash_ajp_usd.${myts}.txt 2>&1

sleep 3

exit 0


