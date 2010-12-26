#!/bin/bash

# expdp_fx.bash

# I use this script to expdp my 2 score tables.

. /pt/s/rluck/svm6/.orcl

set -x
export myts=`date +%Y_%m_%d_%H_%M`

expdp trade/t dumpfile=fxscores6.${myts}.dpdmp tables=fxscores6,fxscores6_gattn

echo "scp -p /oracle/app/oracle/admin/orcl/dpdump/fxscores6.${myts}.dpdmp z:/oracle/app/oracle/admin/orcl/dpdump/"
echo "scp -p /oracle/app/oracle/admin/orcl/dpdump/fxscores6.${myts}.dpdmp h:/oracle/app/oracle/admin/orcl/dpdump/"
echo "scp -p /oracle/app/oracle/admin/orcl/dpdump/fxscores6.${myts}.dpdmp z2:/oracle/app/oracle/admin/orcl/dpdump/"

echo "impdp trade/t table_exists_action=append dumpfile=fxscores6.${myts}.dpdmp"
