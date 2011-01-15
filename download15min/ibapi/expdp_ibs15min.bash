#! /bin/bash

# expdp_ibs15min.bash

# I use this script to expdp price tables for dl15:
# ibs15min
# ibs_old
# ibs_dups_old
# ibs_stage

. /pt/s/rluck/dl15/.orcl

set -x
export myts=`date +%Y_%m_%d_%H_%M`

expdp trade/t dumpfile=ibs15min.${myts}.dpdmp tables=ibs15min,ibs_old,ibs_dups_old,ibs_stage

echo "scp -p /oracle/app/oracle/admin/orcl/dpdump/ibs15min.${myts}.dpdmp h:/oracle/app/oracle/admin/orcl/dpdump/"
echo "scp -p /oracle/app/oracle/admin/orcl/dpdump/ibs15min.${myts}.dpdmp l:/oracle/app/oracle/admin/orcl/dpdump/"
echo "scp -p /oracle/app/oracle/admin/orcl/dpdump/ibs15min.${myts}.dpdmp z:/oracle/app/oracle/admin/orcl/dpdump/"
echo "scp -p /oracle/app/oracle/admin/orcl/dpdump/ibs15min.${myts}.dpdmp z2:/oracle/app/oracle/admin/orcl/dpdump/"
echo "scp -p /oracle/app/oracle/admin/orcl/dpdump/ibs15min.${myts}.dpdmp lz3:/oracle/app/oracle/admin/orcl/dpdump/"

echo "impdp trade/t table_exists_action=append dumpfile=ibs15min.${myts}.dpdmp"
echo OR
echo "impdp trade/t table_exists_action=replace dumpfile=ibs15min.${myts}.dpdmp"
echo "impdp trade/t table_exists_action=replace dumpfile=ibs15min.${myts}.dpdmp tables=ibs15min"

exit

