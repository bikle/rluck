#! /bin/bash

# expdp_di5.bash

# I use this script to expdp price tables for svmspy:
# di5min_stk0
# di5min_stk
# ibs5min
# dukas5min_stk
# dukas10min_stk
# ibs_old
# ibs_dups_old
# ibs_stage

. /pt/s/rluck/svmspy/.orcl

set -x
export myts=`date +%Y_%m_%d_%H_%M`

expdp trade/t dumpfile=svmspy_di5.${myts}.dpdmp tables=di5min_stk0,di5min_stk,ibs5min,dukas5min_stk,dukas10min_stk,ibs_old,ibs_dups_old,ibs_stage

echo "scp -p /oracle/app/oracle/admin/orcl/dpdump/svmspy_di5.${myts}.dpdmp l:/oracle/app/oracle/admin/orcl/dpdump/"

echo "impdp trade/t table_exists_action=append dumpfile=svmspy_di5.${myts}.dpdmp
echo OR
echo "impdp trade/t table_exists_action=replace dumpfile=svmspy_di5.${myts}.dpdmp

exit

