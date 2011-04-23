#!/bin/bash

# copy_price_and_scores_to.bash


# I use this script to copy prices and scores from point-a to point-b

cd /pt/s/rluck/svmd/

export myts=`date +%Y_%m_%d_%H_%M`

expdp trade/t dumpfile=SVMD.${myts}.DPDMP tables=ystk,ystk_stage,ystk21,ystkscores

echo "scp -p ~/dpdump/SVMD.${myts}.DPDMP usr10@xp:dpdump/"
echo "scp -p ~/dpdump/SVMD.${myts}.DPDMP h:~/dpdump/"
echo "scp -p ~/dpdump/SVMD.${myts}.DPDMP h2:~/dpdump/"
echo "scp -p ~/dpdump/SVMD.${myts}.DPDMP z:~/dpdump/"
echo "scp -p ~/dpdump/SVMD.${myts}.DPDMP z2:~/dpdump/"
echo "scp -p ~/dpdump/SVMD.${myts}.DPDMP z3:~/dpdump/"

echo After scp, do ssh, then:

echo "impdp trade/t table_exists_action=replace dumpfile=SVMD.${myts}.DPDMP"

