#!/bin/bash

# 48hp.bash

# This is a simple shell wrapper for 48hp.sql

. /pt/s/oracle/.orcl

set -x

sqt>48hp.txt<<EOF
@48hp.sql
EOF
