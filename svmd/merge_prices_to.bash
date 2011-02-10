#!/bin/bash

# merge_prices_to.bash

# I use this script to copy-merge prices from point-a to point-b

set -x

cd /pt/s/rluck/svmd/

set -x
export myts=`date +%Y_%m_%d_%H_%M`

echo Create table ystk21 from svmd data for svmspy scoring.

sqt<<EOF
@cr_ystk21.sql
EOF

expdp trade/t dumpfile=ystk.${myts}.dpdmp tables=ystk,ystk_stage,ystk21

echo "scp -p /oracle/app/oracle/admin/orcl/dpdump/ystk.${myts}.dpdmp l:/oracle/app/oracle/admin/orcl/dpdump/"
echo "scp -p /oracle/app/oracle/admin/orcl/dpdump/ystk.${myts}.dpdmp z:/oracle/app/oracle/admin/orcl/dpdump/"
echo "scp -p /oracle/app/oracle/admin/orcl/dpdump/ystk.${myts}.dpdmp h:/oracle/app/oracle/admin/orcl/dpdump/"
echo "scp -p /oracle/app/oracle/admin/orcl/dpdump/ystk.${myts}.dpdmp z2:/oracle/app/oracle/admin/orcl/dpdump/"
echo "scp -p /oracle/app/oracle/admin/orcl/dpdump/ystk.${myts}.dpdmp z3:/oracle/app/oracle/admin/orcl/dpdump/"
echo "scp -p /oracle/app/oracle/admin/orcl/dpdump/ystk.${myts}.dpdmp usr10@xp:dpdump/"

echo "impdp trade/t table_exists_action=replace dumpfile=ystk.${myts}.dpdmp"
