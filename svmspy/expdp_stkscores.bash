#!/bin/bash

# expdp_stkscores.bash

# I use this script to expdp my score table.

. /pt/s/rluck/svmspy/.orcl

set -x
export myts=`date +%Y_%m_%d_%H_%M`

expdp trade/t dumpfile=stkscores.${myts}.dpdmp tables=stkscores

echo "scp -p /oracle/app/oracle/admin/orcl/dpdump/stkscores.${myts}.dpdmp z:/oracle/app/oracle/admin/orcl/dpdump/"
echo "scp -p /oracle/app/oracle/admin/orcl/dpdump/stkscores.${myts}.dpdmp h:/oracle/app/oracle/admin/orcl/dpdump/"
echo "scp -p /oracle/app/oracle/admin/orcl/dpdump/stkscores.${myts}.dpdmp z2:/oracle/app/oracle/admin/orcl/dpdump/"

echo "impdp trade/t table_exists_action=append dumpfile=stkscores.${myts}.dpdmp"
