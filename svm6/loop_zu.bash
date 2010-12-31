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

#ech
./ech_svm.bash > /pt/s/cron/out/ech_svm.${myts}.txt 2>&1

# broken:
#egb 
## cd $SVM6/ibapi
## # I need a table:
## ./run5min_data.bash > /pt/s/cron/out/run5min_data.egb.${myts}.txt 2>&1
## sqt>/pt/s/cron/out/update_di5min.egb.${myts}.txt<<EOF
## @update_di5min.sql
## EOF
## cd $SVM6/svm/
## ./bld_run_big610.bash > /pt/s/cron/out/bld_run_big610.${myts}.txt 2>&1
## chmod +x *bash
## ./egb_svm.bash > /pt/s/cron/out/egb_svm.${myts}.txt 2>&1

#ejp 
cd $SVM6/ibapi
# I need a table:
./run5min_data.bash > /pt/s/cron/out/run5min_data.ejp.${myts}.txt 2>&1
sqt>/pt/s/cron/out/update_di5min.ejp.${myts}.txt<<EOF
@update_di5min.sql
EOF
cd $SVM6/svm/
./bld_run_big610.bash > /pt/s/cron/out/bld_run_big610.${myts}.txt 2>&1
chmod +x *bash
./ejp_svm.bash > /pt/s/cron/out/ejp_svm.${myts}.txt 2>&1

#ajp 
cd $SVM6/ibapi
# I need a table:
./run5min_data.bash > /pt/s/cron/out/run5min_data.ajp.${myts}.txt 2>&1
sqt>/pt/s/cron/out/update_di5min.ajp.${myts}.txt<<EOF
@update_di5min.sql
EOF
cd $SVM6/svm/
./bld_run_big610.bash > /pt/s/cron/out/bld_run_big610.${myts}.txt 2>&1
chmod +x *bash
./ajp_svm.bash > /pt/s/cron/out/ajp_svm.${myts}.txt 2>&1
