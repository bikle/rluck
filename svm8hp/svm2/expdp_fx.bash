#!/bin/bash

# expdp_fx.bash

# I use this script to expdp my 2 score tables.

. /pt/s/rluck/svm8hp/.orcl

set -x
export myts=`date +%Y_%m_%d_%H_%M`

expdp trade/t dumpfile=fxscores8hp.${myts}.dpdmp tables=fxscores8hp,fxscores8hp_gattn

echo "scp -p /oracle/app/oracle/admin/orcl/dpdump/fxscores8hp.${myts}.dpdmp z:/oracle/app/oracle/admin/orcl/dpdump/"
echo "scp -p /oracle/app/oracle/admin/orcl/dpdump/fxscores8hp.${myts}.dpdmp h:/oracle/app/oracle/admin/orcl/dpdump/"
