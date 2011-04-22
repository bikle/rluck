#!/bin/bash

# copy_price_and_scores_to.bash

# I use this script to copy prices and scores from point-a to point-b

cd /pt/s/rluck/svmspy/ibapi/

export myts=`date +%Y_%m_%d_%H_%M`

expdp trade/t dumpfile=svmspy_di5.${myts}.dpdmp tables=di5min_stk0,di5min_stk,ibs5min,ibs_old,ibs_dups_old,ibs_stage,di5min_stk_c2,stkscores

echo "scp -p ~/dpdump/svmspy_di5.${myts}.dpdmp usr10@xp:dpdump/"
echo "scp -p ~/dpdump/svmspy_di5.${myts}.dpdmp h:~/dpdump/"
echo "scp -p ~/dpdump/svmspy_di5.${myts}.dpdmp h2:~/dpdump/"
echo "scp -p ~/dpdump/svmspy_di5.${myts}.dpdmp z:~/dpdump/"
echo "scp -p ~/dpdump/svmspy_di5.${myts}.dpdmp z2:~/dpdump/"
echo "scp -p ~/dpdump/svmspy_di5.${myts}.dpdmp z3:~/dpdump/"

echo After scp, do ssh, then:

echo "impdp trade/t table_exists_action=replace dumpfile=svmspy_di5.${myts}.dpdmp tables=di5min_stk_c2,ibs_stage"
echo "impdp trade/t table_exists_action=append dumpfile=svmspy_di5.${myts}.dpdmp tables=ibs5min,stkscores"
echo "sqt @de_dup_stkscores"
echo "sqt @ibapi/merge"

