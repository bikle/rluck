#! /bin/bash

# expdp_ibs15min.bash

# I use this script to expdp price tables for dl15:
# ibs15min
# ibs15min_old
# ibs15min_dups_old
# ibs15min_stage

. /pt/s/rluck/dl15/.orcl

export myts=`date +%Y_%m_%d_%H_%M`

expdp trade/t dumpfile=ibs15min.${myts}.dpdmp tables=ibs15min,ibs15min_old,ibs15min_dups_old,ibs15min_stage

echo "scp -p ~/dpdump/ibs15min.${myts}.dpdmp h:dpdump/"
echo "scp -p ~/dpdump/ibs15min.${myts}.dpdmp h2:dpdump/"
echo "scp -p ~/dpdump/ibs15min.${myts}.dpdmp z:dpdump/"
echo "scp -p ~/dpdump/ibs15min.${myts}.dpdmp z2:dpdump/"
echo "scp -p ~/dpdump/ibs15min.${myts}.dpdmp z3:dpdump/"

echo "append:"
echo "impdp trade/t table_exists_action=append dumpfile=ibs15min.${myts}.dpdmp"
echo "impdp trade/t table_exists_action=append dumpfile=ibs15min.${myts}.dpdmp tables=ibs15min"
echo "replace:"
echo "impdp trade/t table_exists_action=replace dumpfile=ibs15min.${myts}.dpdmp"

exit

