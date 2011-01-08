#!/bin/bash

# expdp1hr.bash

. /pt/s/rluck/svmhstk/.orcl

set -x
export myts=`date +%Y_%m_%d_%H_%M`

expdp trade/t dumpfile=svmhstk_di5.${myts}.dpdmp tables=di1hr_stk0,di1hr_stk,ibs1hr,ibs_dups,ibs_old,dukas1hr_stk,ibs_stage

echo "scp -p /oracle/app/oracle/admin/orcl/dpdump/svmspy_di5.${myts}.dpdmp l:/oracle/app/oracle/admin/orcl/dpdump/"

echo "impdp trade/t table_exists_action=append dumpfile=svmspy_di5.${myts}.dpdmp"
echo OR
echo "impdp trade/t table_exists_action=replace dumpfile=svmspy_di5.${myts}.dpdmp"

exit
