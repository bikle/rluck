#!/bin/bash

# de_dup_stkscores.bash

. /pt/s/rluck/svmspy/.orcl

set -x

cd /pt/s/rluck/svmspy/

export myts=`date +%Y_%m_%d_%H_%M`
expdp trade/t dumpfile=stkscores.${myts}.de_dup.dpdmp tables=stkscores

sqt>de_dup_stkscores.txt<<EOF
@de_dup_stkscores.sql
EOF

cat de_dup_stkscores.txt
