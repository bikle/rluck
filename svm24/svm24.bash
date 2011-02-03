#!/bin/bash

# svm24.bash

# I use this script as an entry point into my efforts to run SVM

. /pt/s/rluck/svm24/.orcl
. /pt/s/rluck/svm24/.jruby

set -x

export myts=`date +%Y_%m_%d_%H_%M`

date

cd $SVM24

./svmpair.bash usd_jpy > /pt/s/cron/out/svm24.usd_jpy.${myts}.txt 2>&1
date
./svmpair.bash eur_usd > /pt/s/cron/out/svm24.eur_usd.${myts}.txt 2>&1
date
./svmpair.bash usd_cad > /pt/s/cron/out/svm24.usd_cad.${myts}.txt 2>&1

date

exit
