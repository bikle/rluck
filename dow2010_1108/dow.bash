#!/bin/bash

# dow.bash

# This is a simple shell wrapper for dow.sql

. /pt/s/oracle/.orcl

set -x

sqt>dow.txt<<EOF
@dow.sql
EOF
