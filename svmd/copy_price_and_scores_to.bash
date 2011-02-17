#!/bin/bash

# copy_price_and_scores_to.bash


# I use this script to copy prices and scores from point-a to point-b

set -x

cd /pt/s/rluck/svmd/

set -x
export myts=`date +%Y_%m_%d_%H_%M`

expdp trade/t dumpfile=svmd.${myts}.dpdmp tables=ystk,ystk_stage,ystk21,ystkscores

echo "scp -p /oracle/app/oracle/admin/orcl/dpdump/svmd.${myts}.dpdmp usr10@xp:dpdump/"
echo "scp -p /oracle/app/oracle/admin/orcl/dpdump/svmd.${myts}.dpdmp l:/oracle/app/oracle/admin/orcl/dpdump/"
echo "scp -p /oracle/app/oracle/admin/orcl/dpdump/svmd.${myts}.dpdmp h:/oracle/app/oracle/admin/orcl/dpdump/"
echo "scp -p /oracle/app/oracle/admin/orcl/dpdump/svmd.${myts}.dpdmp z:/oracle/app/oracle/admin/orcl/dpdump/"
echo "scp -p /oracle/app/oracle/admin/orcl/dpdump/svmd.${myts}.dpdmp z2:/oracle/app/oracle/admin/orcl/dpdump/"
echo "scp -p /oracle/app/oracle/admin/orcl/dpdump/svmd.${myts}.dpdmp z3:/oracle/app/oracle/admin/orcl/dpdump/"

echo After scp, do ssh, then:

echo "impdp trade/t table_exists_action=replace dumpfile=svmd.${myts}.dpdmp"

