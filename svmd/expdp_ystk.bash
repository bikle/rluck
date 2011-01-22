#!/bin/bash

# expdp_ystk.bash

. /pt/s/rluck/svmd/.orcl


set -x
export myts=`date +%Y_%m_%d_%H_%M`

expdp trade/t dumpfile=ystk.${myts}.dpdmp tables=ystk

echo "scp -p /oracle/app/oracle/admin/orcl/dpdump/ystk.${myts}.dpdmp l:/oracle/app/oracle/admin/orcl/dpdump/"
echo "scp -p /oracle/app/oracle/admin/orcl/dpdump/ystk.${myts}.dpdmp z:/oracle/app/oracle/admin/orcl/dpdump/"
echo "scp -p /oracle/app/oracle/admin/orcl/dpdump/ystk.${myts}.dpdmp h:/oracle/app/oracle/admin/orcl/dpdump/"
echo "scp -p /oracle/app/oracle/admin/orcl/dpdump/ystk.${myts}.dpdmp z2:/oracle/app/oracle/admin/orcl/dpdump/"
echo "scp -p /oracle/app/oracle/admin/orcl/dpdump/ystk.${myts}.dpdmp z3:/oracle/app/oracle/admin/orcl/dpdump/"

echo "impdp trade/t table_exists_action=replace dumpfile=ystk.${myts}.dpdmp"
