#!/bin/bash

# qry_djd.bash

# I use this shell script to wrap a call to my sql script: qry_djd.sql

. /pt/s/oracle/.orcl

set -x

sqt>qry_djd.txt<<EOF
@qry_djd.sql
EOF
