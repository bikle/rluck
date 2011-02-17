#!/bin/bash

# copy_price_and_scores_to.bash


# I use this script to copy prices and scores from point-a to point-b

set -x

cd /pt/s/rluck/svmspy/ibapi/

set -x
export myts=`date +%Y_%m_%d_%H_%M`

expdp trade/t dumpfile=svmspy_di5.${myts}.dpdmp tables=di5min_stk0,di5min_stk,ibs5min,ibs_old,ibs_dups_old,ibs_stage,di5min_stk_c2,stkscores

echo "scp -p /oracle/app/oracle/admin/orcl/dpdump/svmspy_di5.${myts}.dpdmp usr10@xp:dpdump/"
echo "scp -p /oracle/app/oracle/admin/orcl/dpdump/svmspy_di5.${myts}.dpdmp l:/oracle/app/oracle/admin/orcl/dpdump/"
echo "scp -p /oracle/app/oracle/admin/orcl/dpdump/svmspy_di5.${myts}.dpdmp h:/oracle/app/oracle/admin/orcl/dpdump/"
echo "scp -p /oracle/app/oracle/admin/orcl/dpdump/svmspy_di5.${myts}.dpdmp z:/oracle/app/oracle/admin/orcl/dpdump/"
echo "scp -p /oracle/app/oracle/admin/orcl/dpdump/svmspy_di5.${myts}.dpdmp z2:/oracle/app/oracle/admin/orcl/dpdump/"
echo "scp -p /oracle/app/oracle/admin/orcl/dpdump/svmspy_di5.${myts}.dpdmp z3:/oracle/app/oracle/admin/orcl/dpdump/"

echo After scp, do ssh, then:

echo "impdp trade/t table_exists_action=replace dumpfile=svmspy_di5.${myts}.dpdmp"

