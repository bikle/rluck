#!/bin/bash

# merge_ystkscores_to.bash

# I use this script to copy-merge ystkscores from point-A to point-B
# Demo:
# ./merge_ystkscores_to.bash z2

set -x
cd /pt/s/rluck/svmd/


set -x
export myts=`date +%Y_%m_%d_%H_%M`

expdp trade/t dumpfile=ystkscores.${myts}.dpdmp tables=ystkscores

echo "scp -p /oracle/app/oracle/admin/orcl/dpdump/ystkscores.${myts}.dpdmp ${1}:/oracle/app/oracle/admin/orcl/dpdump/"

echo ssh $1

echo "impdp trade/t table_exists_action=append dumpfile=ystkscores.${myts}.dpdmp"

echo cd /pt/s/rluck/svmd/

echo ./de_dup_scores.bash
