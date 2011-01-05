#! /bin/bash
# exp_svmhstk.bash

. /pt/s/rluck/svmhstk/.orcl

set -x
export myts=`date +%Y_%m_%d_%H_%M`

expdp trade/t dumpfile=svmhstk.${myts}.dpdmp tables=dukas1hr_stk,hstage,ibs1hr,stkscores_1hr

echo "scp -p /oracle/app/oracle/admin/orcl/dpdump/svmhstk.${myts}.dpdmp z:/oracle/app/oracle/admin/orcl/dpdump/"
echo "scp -p /oracle/app/oracle/admin/orcl/dpdump/svmhstk.${myts}.dpdmp h:/oracle/app/oracle/admin/orcl/dpdump/"
echo "scp -p /oracle/app/oracle/admin/orcl/dpdump/svmhstk.${myts}.dpdmp l:/oracle/app/oracle/admin/orcl/dpdump/"

echo "impdp trade/t table_exists_action=append dumpfile=svmhstk.${myts}.dpdmp"
