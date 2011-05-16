#!/bin/bash

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

./dl_then_svm.bash aud_jpy > /pt/s/cron/out/dl_then_svm_aud_jpy.${myts}.txt 2>&1
./svmpair.bash eur_aud > /pt/s/cron/out/svm_bash_eur_aud.${myts}.txt 2>&1
./svmpair.bash eur_chf > /pt/s/cron/out/svm_bash_eur_chf.${myts}.txt 2>&1
./svmpair.bash eur_gbp > /pt/s/cron/out/svm_bash_eur_gbp.${myts}.txt 2>&1
./svmpair.bash eur_jpy > /pt/s/cron/out/svm_bash_eur_jpy.${myts}.txt 2>&1

