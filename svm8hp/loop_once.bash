#!/bin/bash

# loop_once.bash

# I call this script from loop_til_sat.bash

# It allows me to change what loop_til_sat.bash does without stopping it.

# I run this script frequently, perhaps every 10 minutes.

. /pt/s/rluck/svm8hp/.orcl
. /pt/s/rluck/svm8hp/.jruby

set -x 

cd $SVM8HP
cd ibapi
export myts=`date +%Y_%m_%d_%H_%M`
# I need a table:
./run5min_data.bash > /pt/s/cron/out/run5min_data.${myts}.txt 2>&1
sqt>/pt/s/cron/out/update_di5min.${myts}.txt<<EOF
@update_di5min.sql
EOF
cd ../svm2/
# Now I generate some scripts from some templates:
jruby sedem.rb
# Now, for each pair, I create some tables full of model attributes:
# aud_ms10, aud_att, ... , chf_ms10, chf_att
./bld_run_big10.bash > /pt/s/cron/out/bld_run_big10.${myts}.txt 2>&1
# Now, for each pair, run SVM and collect the scores:
chmod +x *bash
./aud_svm2.bash > /pt/s/cron/out/aud_svm2.${myts}.txt 2>&1
# act on the scores:
cd ../openclose/
./oc.bash  > /pt/s/cron/out/oc.bash.${myts}.txt 2>&1


# Now do eur_usd:
cd $SVM8HP
cd ibapi
export myts=`date +%Y_%m_%d_%H_%M`
# I need a table:
./run5min_data.bash > /pt/s/cron/out/run5min_data.${myts}.txt 2>&1
sqt>/pt/s/cron/out/update_di5min.${myts}.txt<<EOF
@update_di5min.sql
EOF
cd ../svm2/
./bld_run_big10.bash > /pt/s/cron/out/bld_run_big10.${myts}.txt 2>&1
chmod +x *bash
./eur_svm2.bash > /pt/s/cron/out/eur_svm2.${myts}.txt 2>&1
# act on the scores:
cd ../openclose/
./oc.bash  > /pt/s/cron/out/oc.bash.${myts}.txt 2>&1

# Now do gbp_usd:
cd $SVM8HP
cd ibapi
export myts=`date +%Y_%m_%d_%H_%M`
# I need a table:
./run5min_data.bash > /pt/s/cron/out/run5min_data.${myts}.txt 2>&1
sqt>/pt/s/cron/out/update_di5min.${myts}.txt<<EOF
@update_di5min.sql
EOF
cd ../svm2/
./bld_run_big10.bash > /pt/s/cron/out/bld_run_big10.${myts}.txt 2>&1
chmod +x *bash
./gbp_svm2.bash > /pt/s/cron/out/gbp_svm2.${myts}.txt 2>&1
# act on the scores:
cd ../openclose/
./oc.bash  > /pt/s/cron/out/oc.bash.${myts}.txt 2>&1

# Now do usd_cad:
cd $SVM8HP
cd ibapi
export myts=`date +%Y_%m_%d_%H_%M`
# I need a table:
./run5min_data.bash > /pt/s/cron/out/run5min_data.${myts}.txt 2>&1
sqt>/pt/s/cron/out/update_di5min.${myts}.txt<<EOF
@update_di5min.sql
EOF
cd ../svm2/
./bld_run_big10.bash > /pt/s/cron/out/bld_run_big10.${myts}.txt 2>&1
chmod +x *bash
./cad_svm2.bash > /pt/s/cron/out/cad_svm2.${myts}.txt 2>&1
# act on the scores:
cd ../openclose/
./oc.bash  > /pt/s/cron/out/oc.bash.${myts}.txt 2>&1

# Now do usd_chf:
cd $SVM8HP
cd ibapi
export myts=`date +%Y_%m_%d_%H_%M`
# I need a table:
./run5min_data.bash > /pt/s/cron/out/run5min_data.${myts}.txt 2>&1
sqt>/pt/s/cron/out/update_di5min.${myts}.txt<<EOF
@update_di5min.sql
EOF
cd ../svm2/
./bld_run_big10.bash > /pt/s/cron/out/bld_run_big10.${myts}.txt 2>&1
chmod +x *bash
./chf_svm2.bash > /pt/s/cron/out/chf_svm2.${myts}.txt 2>&1
# act on the scores:
cd ../openclose/
./oc.bash  > /pt/s/cron/out/oc.bash.${myts}.txt 2>&1

# Now do usd_jpy:
cd $SVM8HP
cd ibapi
export myts=`date +%Y_%m_%d_%H_%M`
# I need a table:
./run5min_data.bash > /pt/s/cron/out/run5min_data.${myts}.txt 2>&1
sqt>/pt/s/cron/out/update_di5min.${myts}.txt<<EOF
@update_di5min.sql
EOF
cd ../svm2/
./bld_run_big10.bash > /pt/s/cron/out/bld_run_big10.${myts}.txt 2>&1
chmod +x *bash
./jpy_svm2.bash > /pt/s/cron/out/jpy_svm2.${myts}.txt 2>&1
# act on the scores:
cd ../openclose/
./oc.bash  > /pt/s/cron/out/oc.bash.${myts}.txt 2>&1

exit
