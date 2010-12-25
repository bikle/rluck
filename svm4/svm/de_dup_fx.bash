#!/bin/bash

# de_dup_fx.bash

. /pt/s/rluck/svm6/.orcl

set -x
export myts=`date +%Y_%m_%d_%H_%M`
expdp trade/t dumpfile=fxscores6.${myts}.dpdmp tables=fxscores6,fxscores6_gattn

sqt>de_dup_fx.txt<<EOF
@de_dup_fx.sql
EOF

cat de_dup_fx.txt
