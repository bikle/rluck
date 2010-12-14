#!/bin/bash

# svm4hp.bash

# I use this script as an entry point into a backtest of the svm4hp strategy.

. /pt/s/oracle/.orcl
. /pt/s/oracle/.jruby

set -x
cd $SVM4HP
cd svm2/

export myts=`date +%Y_%m_%d_%H_%M`

jruby sedem.rb

./bld_run_big10.bash > /pt/s/cron/out/bld_run_big10.${myts}.txt 2>&1


