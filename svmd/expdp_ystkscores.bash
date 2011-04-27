#!/bin/bash

# expdp_ystkscores.bash

. /pt/s/rluck/svmd/.orcl

export myts=`date +%Y_%m_%d_%H_%M`

expdp trade/t dumpfile=YSTKSCORES.${myts}.DPDMP tables=YSTKSCORES

echo "scp -p ~/dpdump/YSTKSCORES.${myts}.DPDMP h:dpdump/"
echo "scp -p ~/dpdump/YSTKSCORES.${myts}.DPDMP h2:dpdump/"
echo "scp -p ~/dpdump/YSTKSCORES.${myts}.DPDMP z:dpdump/"
echo "scp -p ~/dpdump/YSTKSCORES.${myts}.DPDMP z2:dpdump/"
echo "scp -p ~/dpdump/YSTKSCORES.${myts}.DPDMP z3:dpdump/"
echo "scp -p ~/dpdump/YSTKSCORES.${myts}.DPDMP usr10@xp:dpdump/"

echo "impdp trade/t table_exists_action=append dumpfile=YSTKSCORES.${myts}.DPDMP"
