#!/bin/bash

# qry_wjw11woq.bash

# I use this shell script to wrap a call to my sql script: qry_wjw11woq.sql

. /pt/s/oracle/.orcl

set -x

sqt>qry_wjw11woq.txt<<EOF
@qry_wjw11woq.sql
EOF
