#!/bin/bash

# copy_price_and_scores_to.bash


# I use this script to copy prices and scores from point-a to point-b

set -x

cd /pt/s/rluck/svm62

set -x
export myts=`date +%Y_%m_%d_%H_%M`

expdp trade/t dumpfile=svm62_p_s.${myts}.dpdmp tables=di5min,dukas5min,op5min,ibf_old,ibf_dups_old,ibf_dups,ibf_stage,ibf5min,svm62scores

echo "scp -p /oracle/app/oracle/admin/orcl/dpdump/svm62_p_s.${myts}.dpdmp usr10@xp:dpdump/"
echo "scp -p /oracle/app/oracle/admin/orcl/dpdump/svm62_p_s.${myts}.dpdmp l:/oracle/app/oracle/admin/orcl/dpdump/"
echo "scp -p /oracle/app/oracle/admin/orcl/dpdump/svm62_p_s.${myts}.dpdmp h:/oracle/app/oracle/admin/orcl/dpdump/"
echo "scp -p /oracle/app/oracle/admin/orcl/dpdump/svm62_p_s.${myts}.dpdmp z:/oracle/app/oracle/admin/orcl/dpdump/"
echo "scp -p /oracle/app/oracle/admin/orcl/dpdump/svm62_p_s.${myts}.dpdmp z2:/oracle/app/oracle/admin/orcl/dpdump/"
echo "scp -p /oracle/app/oracle/admin/orcl/dpdump/svm62_p_s.${myts}.dpdmp z3:/oracle/app/oracle/admin/orcl/dpdump/"

echo After scp, do ssh, then:

echo "impdp trade/t table_exists_action=append dumpfile=svm62_p_s.${myts}.dpdmp tables=ibf5min,svm62scores"
echo "impdp trade/t table_exists_action=replace dumpfile=svm62_p_s.${myts}.dpdmp tables=di5min,op5min"
echo "sqt @de_dup_svm62scores"
echo "sqt @ibapi/merge"
