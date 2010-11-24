#!/bin/bash

# 4hp.bash

# This is a simple shell wrapper for 4hp.sql

. /pt/s/oracle/.orcl

set -x

sqt>4hp.txt<<EOF
@4hp.sql
EOF
