#!/bin/bash

# 24hp.bash

# This is a simple shell wrapper for 24hp.sql

. /pt/s/oracle/.orcl

set -x

sqt>24hp.txt<<EOF
@24hp.sql
EOF
