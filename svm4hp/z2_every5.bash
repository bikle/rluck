#!/bin/bash

# z2_every5.bash

# I run this script frequently, perhaps every 5 minutes.

. /pt/s/rluck/svm4hp/.orcl
. /pt/s/rluck/svm4hp/.jruby

set -x 

cd $SVM4HP
export myts=`date +%Y_%m_%d_%H_%M`
# I need a table:
/pt/s/api/f/5min_data/run5min_data.bash > /pt/s/cron/out/run5min_data.${myts}.txt 2>&1
sqt>/pt/s/cron/out/update_di5min.${myts}.txt<<EOF
@update_di5min.sql
EOF

# Next I create some scripts and then run SVM:
# ./run_svm4hp.bash > /pt/s/cron/out/svm4hp.${myts}.txt 2>&1

cd svm2/

# Now I generate some scripts from some templates:
jruby sedem.rb

# Now, for each pair, I create some tables full of model attributes:
# aud_ms10, aud_att, ... , chf_ms10, chf_att
./bld_run_big10.bash > /pt/s/cron/out/bld_run_big10.${myts}.txt 2>&1
# Now, for each pair, run SVM and collect the scores:
chmod +x *bash
./aud_svm2.bash > /pt/s/cron/out/aud_svm2.${myts}.txt 2>&1

# Now do eur_usd:
cd $SVM4HP
export myts=`date +%Y_%m_%d_%H_%M`
# I need a table:
/pt/s/api/f/5min_data/run5min_data.bash > /pt/s/cron/out/run5min_data.${myts}.txt 2>&1
sqt>/pt/s/cron/out/update_di5min.${myts}.txt<<EOF
@update_di5min.sql
EOF
cd svm2/
./bld_run_big10.bash > /pt/s/cron/out/bld_run_big10.${myts}.txt 2>&1
./eur_svm2.bash > /pt/s/cron/out/eur_svm2.${myts}.txt 2>&1

# Now do gbp_usd:
cd $SVM4HP
export myts=`date +%Y_%m_%d_%H_%M`
# I need a table:
/pt/s/api/f/5min_data/run5min_data.bash > /pt/s/cron/out/run5min_data.${myts}.txt 2>&1
sqt>/pt/s/cron/out/update_di5min.${myts}.txt<<EOF
@update_di5min.sql
EOF
cd svm2/
./bld_run_big10.bash > /pt/s/cron/out/bld_run_big10.${myts}.txt 2>&1
./gbp_svm2.bash > /pt/s/cron/out/gbp_svm2.${myts}.txt 2>&1

# Now do usd_cad:
cd $SVM4HP
export myts=`date +%Y_%m_%d_%H_%M`
# I need a table:
/pt/s/api/f/5min_data/run5min_data.bash > /pt/s/cron/out/run5min_data.${myts}.txt 2>&1
sqt>/pt/s/cron/out/update_di5min.${myts}.txt<<EOF
@update_di5min.sql
EOF
cd svm2/
./bld_run_big10.bash > /pt/s/cron/out/bld_run_big10.${myts}.txt 2>&1
./cad_svm2.bash > /pt/s/cron/out/cad_svm2.${myts}.txt 2>&1

# Now do usd_chf:
cd $SVM4HP
export myts=`date +%Y_%m_%d_%H_%M`
# I need a table:
/pt/s/api/f/5min_data/run5min_data.bash > /pt/s/cron/out/run5min_data.${myts}.txt 2>&1
sqt>/pt/s/cron/out/update_di5min.${myts}.txt<<EOF
@update_di5min.sql
EOF
cd svm2/
./bld_run_big10.bash > /pt/s/cron/out/bld_run_big10.${myts}.txt 2>&1
./chf_svm2.bash > /pt/s/cron/out/chf_svm2.${myts}.txt 2>&1

# Now do usd_jpy:
cd $SVM4HP
export myts=`date +%Y_%m_%d_%H_%M`
# I need a table:
/pt/s/api/f/5min_data/run5min_data.bash > /pt/s/cron/out/run5min_data.${myts}.txt 2>&1
sqt>/pt/s/cron/out/update_di5min.${myts}.txt<<EOF
@update_di5min.sql
EOF
cd svm2/
./bld_run_big10.bash > /pt/s/cron/out/bld_run_big10.${myts}.txt 2>&1
./jpy_svm2.bash > /pt/s/cron/out/jpy_svm2.${myts}.txt 2>&1

exit
