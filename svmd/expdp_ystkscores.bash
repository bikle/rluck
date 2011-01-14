#!/bin/bash

# expdp_ystkscores.bash

. /pt/s/rluck/svmd/.orcl


set -x
export myts=`date +%Y_%m_%d_%H_%M`

expdp trade/t dumpfile=ystkscores.${myts}.dpdmp tables=ystkscores

echo "scp -p /oracle/app/oracle/admin/orcl/dpdump/ystkscores.${myts}.dpdmp z:/oracle/app/oracle/admin/orcl/dpdump/"
echo "scp -p /oracle/app/oracle/admin/orcl/dpdump/ystkscores.${myts}.dpdmp h:/oracle/app/oracle/admin/orcl/dpdump/"
echo "scp -p /oracle/app/oracle/admin/orcl/dpdump/ystkscores.${myts}.dpdmp z2:/oracle/app/oracle/admin/orcl/dpdump/"
echo "scp -p /oracle/app/oracle/admin/orcl/dpdump/ystkscores.${myts}.dpdmp z3:/oracle/app/oracle/admin/orcl/dpdump/"

echo "impdp trade/t table_exists_action=append dumpfile=ystkscores.${myts}.dpdmp"
