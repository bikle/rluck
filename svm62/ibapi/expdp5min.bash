#!/bin/bash

# expdp5min.bash

. /pt/s/rluck/svm62/.orcl

set -x
export myts=`date +%Y_%m_%d_%H_%M`

cd /pt/s/rluck/svm62/ibapi/

# touch /oracle/app/oracle/admin/orcl/dpdump/x5min.dpdmp
mv /oracle/app/oracle/admin/orcl/dpdump/x5min.dpdmp /oracle/app/oracle/admin/orcl/dpdump/x5min.${myts}.dpdmp

expdp trade/t  dumpfile=x5min.dpdmp tables=ibf5min,di5min,dukas5min,op5min,svm62scores
chmod 644 /oracle/app/oracle/admin/orcl/dpdump/x5min.dpdmp

echo 'scp -p /oracle/app/oracle/admin/orcl/dpdump/x5min.dpdmp z:/oracle/app/oracle/admin/orcl/dpdump'
echo 'scp -p /oracle/app/oracle/admin/orcl/dpdump/x5min.dpdmp usr10@xp:dpdump/'
echo 'impdp trade/t dumpfile=x5min.dpdmp table_exists_action=replace'
echo 'impdp trade/t dumpfile=x5min.dpdmp table_exists_action=append tables=svm62scores'

gzip /oracle/app/oracle/admin/orcl/dpdump/x5min.${myts}.dpdmp
