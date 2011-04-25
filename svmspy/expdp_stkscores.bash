#!/bin/bash

# expdp_stkscores.bash

# I use this script to expdp my score table.

. /pt/s/rluck/svmspy/.orcl

export myts=`date +%Y_%m_%d_%H_%M`

expdp trade/t dumpfile=STKSCORES.${myts}.DPDMP tables=STKSCORES

echo "scp -p ~/dpdump/STKSCORES.${myts}.DPDMP h:dpdump/"
echo "scp -p ~/dpdump/STKSCORES.${myts}.DPDMP h2:dpdump/"
echo "scp -p ~/dpdump/STKSCORES.${myts}.DPDMP z:dpdump/"
echo "scp -p ~/dpdump/STKSCORES.${myts}.DPDMP z2:dpdump/"
echo "scp -p ~/dpdump/STKSCORES.${myts}.DPDMP z3:dpdump/"

echo "scp -p ~/dpdump/STKSCORES.${myts}.DPDMP usr10@xp:dpdump/"

echo "impdp trade/t table_exists_action=append dumpfile=STKSCORES.${myts}.DPDMP"
