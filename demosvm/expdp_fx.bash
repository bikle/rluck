#!/bin/bash

# expdp_fx.bash

# I use this script to expdp my 2 score tables.

. /pt/s/rluck/demosvm/.orcl

set -x
export myts=`date +%Y_%m_%d_%H_%M`

expdp trade/t dumpfile=fxscores_demo.${myts}.dpdmp tables=fxscores_demo_gattn,fxscores_demo

echo "scp -p /oracle/app/oracle/admin/orcl/dpdump/fxscores_demo.${myts}.dpdmp z:/oracle/app/oracle/admin/orcl/dpdump/"

echo "impdp trade/t table_exists_action=append dumpfile=fxscores_demo.${myts}.dpdmp"
