#!/bin/bash

# expdp_stkscores.bash

# I use this script to expdp my score table.

. /pt/s/rluck/svmspy/.orcl

set -x
export myts=`date +%Y_%m_%d_%H_%M`

expdp trade/t dumpfile=STKSCORES.${myts}.DPDMP tables=STKSCORES

echo "scp -p /oracle/app/oracle/admin/orcl/dpdump/STKSCORES.${myts}.DPDMP z:/oracle/app/oracle/admin/orcl/dpdump/"
echo "scp -p /oracle/app/oracle/admin/orcl/dpdump/STKSCORES.${myts}.DPDMP h:/oracle/app/oracle/admin/orcl/dpdump/"
echo "scp -p /oracle/app/oracle/admin/orcl/dpdump/STKSCORES.${myts}.DPDMP z2:/oracle/app/oracle/admin/orcl/dpdump/"
echo "scp -p /oracle/app/oracle/admin/orcl/dpdump/STKSCORES.${myts}.DPDMP z3:/oracle/app/oracle/admin/orcl/dpdump/"
echo "scp -p /oracle/app/oracle/admin/orcl/dpdump/STKSCORES.${myts}.DPDMP l:/oracle/app/oracle/admin/orcl/dpdump/"

echo "scp -p /oracle/app/oracle/admin/orcl/dpdump/STKSCORES.${myts}.DPDMP usr10@xp:dpdump/"

echo "impdp trade/t table_exists_action=append dumpfile=STKSCORES.${myts}.DPDMP"
