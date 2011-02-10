#!/bin/bash

# merge_stkscores_to.bash

# I use this script to copy-merge stkscores from point-A to point-B
# Demo:
# ./merge_stkscores_to.bash z2

set -x
cd /pt/s/rluck/svmspy/


set -x
export myts=`date +%Y_%m_%d_%H_%M`

expdp trade/t dumpfile=stkscores.${myts}.dpdmp tables=stkscores

echo "scp -p /oracle/app/oracle/admin/orcl/dpdump/stkscores.${myts}.dpdmp ${1}:/oracle/app/oracle/admin/orcl/dpdump/"

echo ssh $1

echo "impdp trade/t table_exists_action=append dumpfile=stkscores.${myts}.dpdmp"

echo cd /pt/s/rluck/svmspy/

echo ./de_dup_stkscores.bash
