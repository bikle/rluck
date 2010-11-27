#!/bin/bash

# sparseness.bash

# This is a simple bash wrapper for sparseness.sql
. /pt/s/oracle/.orcl

set -x

# I use sparseness.sql to help me see the frequency of r2m when ma-slope is very steep.
sqt>sparseness.txt<<EOF
@sparseness.sql
EOF

