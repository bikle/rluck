#! /bin/bash

# expdp_ibs5min.bash

# I use this script to expdp price tables for svmspy:
# ibs5min
# ibs_old
# ibs_dups_old
# ibs_stage

. /pt/s/rluck/svmspy/.orcl

set -x
export myts=`date +%Y_%m_%d_%H_%M`

expdp trade/t dumpfile=svmspy_ibs5min.${myts}.dpdmp tables=ibs5min,ibs_old,ibs_dups_old,ibs_stage

echo "scp -p /oracle/app/oracle/admin/orcl/dpdump/svmspy_ibs5min.${myts}.dpdmp l:/oracle/app/oracle/admin/orcl/dpdump/"

echo "impdp trade/t table_exists_action=append dumpfile=svmspy_ibs5min.${myts}.dpdmp"
echo OR
echo "impdp trade/t table_exists_action=replace dumpfile=svmspy_ibs5min.${myts}.dpdmp"

exit

