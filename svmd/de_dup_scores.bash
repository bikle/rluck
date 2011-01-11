#!/bin/bash

# de_dup_scores.bash

. /pt/s/rluck/svmd/.orcl


set -x
export myts=`date +%Y_%m_%d_%H_%M`

expdp trade/t dumpfile=ystkscores.${myts}.dpdmp tables=ystkscores

sqt<<EOF
@de_dup_scores.sql
EOF

