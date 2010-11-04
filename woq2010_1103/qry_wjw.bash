#!/bin/bash

# qry_wjw.bash

# I use this shell script to wrap a call to my sql script: qry_wjw.sql

. /pt/s/oracle/.orcl

set -x

sqt>qry_wjw.txt<<EOF
@qry_wjw.sql
EOF
