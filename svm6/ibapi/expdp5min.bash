#!/bin/bash

# expdp5min.bash

. /pt/s/rluck/svm6/.orcl

set -x
export myts=`date +%Y_%m_%d_%H_%M`

cd /pt/s/rluck/svm6/ibapi/

# touch /oracle/app/oracle/admin/orcl/dpdump/x5min.dpdmp
mv /oracle/app/oracle/admin/orcl/dpdump/x5min.dpdmp /oracle/app/oracle/admin/orcl/dpdump/x5min.${myts}.dpdmp

expdp trade/t  dumpfile=x5min.dpdmp tables=ibf5min,di5min,dukas5min

echo 'scp -p /oracle/app/oracle/admin/orcl/dpdump/x5min.dpdmp z:/oracle/app/oracle/admin/orcl/dpdump'
echo 'impdp trade/t dumpfile=x5min.dpdmp table_exists_action=replace'

gzip /oracle/app/oracle/admin/orcl/dpdump/x5min.${myts}.dpdmp
