#!/bin/bash

# 6hp.bash

# This is a simple shell wrapper for 6hp.sql

. /pt/s/oracle/.orcl

set -x

sqt>6hp.txt<<EOF
@6hp.sql
EOF
