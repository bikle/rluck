#!/bin/bash

# 12hp.bash

# This is a simple shell wrapper for 12hp.sql

. /pt/s/oracle/.orcl

set -x

sqt>12hp.txt<<EOF
@12hp.sql
EOF
