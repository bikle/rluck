#!/bin/bash

# expdp_ibf5min.bash

. /pt/s/rluck/svm62/.orcl

set -x
export myts=`date +%Y_%m_%d_%H_%M`

cd /pt/s/rluck/svm62/ibapi/

# touch /oracle/app/oracle/admin/orcl/dpdump/x5min.dpdmp
mv /oracle/app/oracle/admin/orcl/dpdump/x5min.dpdmp /oracle/app/oracle/admin/orcl/dpdump/x5min.${myts}.dpdmp

expdp trade/t  dumpfile=x5min.dpdmp tables=ibf5min,di5min,dukas5min,op5min,svm62scores,ibf_old,ibf_dups_old,ibf_dups,ibf_stage
chmod 644 /oracle/app/oracle/admin/orcl/dpdump/x5min.dpdmp

echo 'scp -p /oracle/app/oracle/admin/orcl/dpdump/x5min.dpdmp z:/oracle/app/oracle/admin/orcl/dpdump'
echo 'scp -p /oracle/app/oracle/admin/orcl/dpdump/x5min.dpdmp z2:/oracle/app/oracle/admin/orcl/dpdump'
echo 'scp -p /oracle/app/oracle/admin/orcl/dpdump/x5min.dpdmp z3:/oracle/app/oracle/admin/orcl/dpdump'
echo 'scp -p /oracle/app/oracle/admin/orcl/dpdump/x5min.dpdmp usr10@xp:dpdump/'
echo 'impdp trade/t dumpfile=x5min.dpdmp table_exists_action=append tables=ibf5min'
echo 'sqt @/pt/s/rluck/svm62/ibapi/merge.sql'
echo 'sqt @/pt/s/rluck/svm62/ibapi/update_di5min.sql'

gzip /oracle/app/oracle/admin/orcl/dpdump/x5min.${myts}.dpdmp
