#!/bin/bash

# /pt/s/rluck/svm4hp/impdp_file.bash

. /pt/s/rluck/svm4hp/.orcl

# I copy the dpdump file to where Oracle can read it:
cp -p expdp_some.z2.2010_12_15_02_32.dpdmp.gz  ${ORACLE_BASE}/admin/orcl/dpdump/

# Copy the data into Oracle
gunzip ${ORACLE_BASE}/admin/orcl/dpdump/expdp_some.z2.2010_12_15_02_32.dpdmp
impdp trade/t table_exists_action=replace dumpfile=expdp_some.z2.2010_12_15_02_32.dpdmp
