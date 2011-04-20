#!/bin/bash

# expdp_stkscores.bash

# I use this script to expdp my score table.

export myts=`date +%Y_%m_%d_%H_%M`

expdp trade/t dumpfile=STKSCORES.${myts}.DPDMP tables=STKSCORES

echo "scp -p ~/dpdump/STKSCORES.${myts}.DPDMP oracle@z:/oracle/app/oracle/admin/orcl/dpdump/"
echo "scp -p ~/dpdump/STKSCORES.${myts}.DPDMP oracle@h:/oracle/app/oracle/admin/orcl/dpdump/"
echo "scp -p ~/dpdump/STKSCORES.${myts}.DPDMP oracle@z2:/oracle/app/oracle/admin/orcl/dpdump/"
echo "scp -p ~/dpdump/STKSCORES.${myts}.DPDMP oracle@z3:/oracle/app/oracle/admin/orcl/dpdump/"

echo "scp -p ~/dpdump/STKSCORES.${myts}.DPDMP usr10@xp:dpdump/"

echo "impdp trade/t table_exists_action=append dumpfile=STKSCORES.${myts}.DPDMP"
