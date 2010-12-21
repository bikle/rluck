#!/bin/bash

# 8hp.bash

# This is a simple shell wrapper for 8hp.sql

. /pt/s/oracle/.orcl

set -x

sqt>8hp.txt<<EOF
@8hp.sql
EOF
