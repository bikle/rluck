#!/bin/bash

# loop_once.bash

# I call this script from loop_til_sat.bash

# It allows me to change what loop_til_sat.bash does without stopping it.

# I run this script frequently, perhaps every 10 minutes.

#debug
/pt/s/rluck/svm6/test1thing.bash > /pt/s/cron/out/test1thing.txt 2>&1
#debug

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

#aud
./aud_svm.bash > /pt/s/cron/out/aud_svm.${myts}.txt 2>&1
cd $SVM6/openclose/
./oc.bash aud > /pt/s/cron/out/oc_bash.${myts}.aud.txt 2>&1

#jpy 
cd $SVM6/ibapi
# I need a table:
./run5min_data.bash > /pt/s/cron/out/run5min_data.${myts}.txt 2>&1
sqt>/pt/s/cron/out/update_di5min.${myts}.txt<<EOF
@update_di5min.sql
EOF
cd $SVM6/svm/
./bld_run_big610.bash > /pt/s/cron/out/bld_run_big610.${myts}.txt 2>&1
chmod +x *bash
./jpy_svm.bash > /pt/s/cron/out/jpy_svm.${myts}.txt 2>&1
cd $SVM6/openclose/
./oc.bash jpy > /pt/s/cron/out/oc_bash.${myts}.jpy.txt 2>&1

#eur 
cd $SVM6/ibapi
# I need a table:
./run5min_data.bash > /pt/s/cron/out/run5min_data.${myts}.txt 2>&1
sqt>/pt/s/cron/out/update_di5min.${myts}.txt<<EOF
@update_di5min.sql
EOF
cd $SVM6/svm/
./bld_run_big610.bash > /pt/s/cron/out/bld_run_big610.${myts}.txt 2>&1
chmod +x *bash
./eur_svm.bash > /pt/s/cron/out/eur_svm.${myts}.txt 2>&1
cd $SVM6/openclose/
./oc.bash eur > /pt/s/cron/out/oc_bash.${myts}.eur.txt 2>&1

#gbp 
cd $SVM6/ibapi
# I need a table:
./run5min_data.bash > /pt/s/cron/out/run5min_data.${myts}.txt 2>&1
sqt>/pt/s/cron/out/update_di5min.${myts}.txt<<EOF
@update_di5min.sql
EOF
cd $SVM6/svm/
./bld_run_big610.bash > /pt/s/cron/out/bld_run_big610.${myts}.txt 2>&1
chmod +x *bash
./gbp_svm.bash > /pt/s/cron/out/gbp_svm.${myts}.txt 2>&1
cd $SVM6/openclose/
./oc.bash gbp > /pt/s/cron/out/oc_bash.${myts}.gbp.txt 2>&1


#chf 
cd $SVM6/ibapi
# I need a table:
./run5min_data.bash > /pt/s/cron/out/run5min_data.${myts}.txt 2>&1
sqt>/pt/s/cron/out/update_di5min.${myts}.txt<<EOF
@update_di5min.sql
EOF
cd $SVM6/svm/
./bld_run_big610.bash > /pt/s/cron/out/bld_run_big610.${myts}.txt 2>&1
chmod +x *bash
./chf_svm.bash > /pt/s/cron/out/chf_svm.${myts}.txt 2>&1
cd $SVM6/openclose/
./oc.bash chf > /pt/s/cron/out/oc_bash.${myts}.chf.txt 2>&1

#cad 
cd $SVM6/ibapi
# I need a table:
./run5min_data.bash > /pt/s/cron/out/run5min_data.${myts}.txt 2>&1
sqt>/pt/s/cron/out/update_di5min.${myts}.txt<<EOF
@update_di5min.sql
EOF
cd $SVM6/svm/
./bld_run_big610.bash > /pt/s/cron/out/bld_run_big610.${myts}.txt 2>&1
chmod +x *bash
./cad_svm.bash > /pt/s/cron/out/cad_svm.${myts}.txt 2>&1
cd $SVM6/openclose/
./oc.bash cad > /pt/s/cron/out/oc_bash.${myts}.cad.txt 2>&1

exit




