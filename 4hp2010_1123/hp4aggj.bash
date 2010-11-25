#!/bin/bash

# hp4aggj.bash

# This is a simple shell wrapper for hp4aggj.sql

. /pt/s/oracle/.orcl

set -x

sqt>hp4aggj.txt<<EOF
@hp4aggj.sql
EOF
