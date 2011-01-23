#!/bin/bash

# de_dup_svm62scores.bash

. /pt/s/rluck/svm62/.orcl

set -x

cd /pt/s/rluck/svm62/

export myts=`date +%Y_%m_%d_%H_%M`
expdp trade/t dumpfile=svm62scores.${myts}.de_dup.dpdmp tables=svm62scores

sqt>de_dup_svm62scores.txt<<EOF
@de_dup_svm62scores.sql
EOF

cat de_dup_svm62scores.txt
