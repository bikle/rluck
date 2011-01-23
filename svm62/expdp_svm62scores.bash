#!/bin/bash

# expdp_svm62scores.bash

# I use this script to expdp my score table.

. /pt/s/rluck/svmspy/.orcl

set -x
export myts=`date +%Y_%m_%d_%H_%M`

expdp trade/t dumpfile=svm62scores.${myts}.dpdmp tables=svm62scores

echo "scp -p /oracle/app/oracle/admin/orcl/dpdump/svm62scores.${myts}.dpdmp z:/oracle/app/oracle/admin/orcl/dpdump/"
echo "scp -p /oracle/app/oracle/admin/orcl/dpdump/svm62scores.${myts}.dpdmp h:/oracle/app/oracle/admin/orcl/dpdump/"
echo "scp -p /oracle/app/oracle/admin/orcl/dpdump/svm62scores.${myts}.dpdmp z2:/oracle/app/oracle/admin/orcl/dpdump/"
echo "scp -p /oracle/app/oracle/admin/orcl/dpdump/svm62scores.${myts}.dpdmp z3:/oracle/app/oracle/admin/orcl/dpdump/"
echo "scp -p /oracle/app/oracle/admin/orcl/dpdump/svm62scores.${myts}.dpdmp l:/oracle/app/oracle/admin/orcl/dpdump/"

echo "scp -p /oracle/app/oracle/admin/orcl/dpdump/svm62scores.${myts}.dpdmp usr10@xp:dpdump/"

echo "impdp trade/t table_exists_action=append dumpfile=svm62scores.${myts}.dpdmp tables=svm62scores"
