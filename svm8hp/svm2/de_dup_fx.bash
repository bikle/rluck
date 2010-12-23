#!/bin/bash

# de_dup_fx.bash

. /pt/s/rluck/svm8hp/.orcl

set -x
export myts=`date +%Y_%m_%d_%H_%M`
expdp trade/t dumpfile=fxscores8hp.${myts}.dpdmp tables=fxscores8hp,fxscores8hp_gattn

sqt>de_dup_fx.txt<<EOF
@de_dup_fx.sql
EOF

cat de_dup_fx.txt
