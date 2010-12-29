#!/bin/bash

# demosvm.bash

# I use this script as an entry point into my efforts to demonstrate SVM.

. /pt/s/rluck/demosvm/.orcl

set -x

date

# Run a SQL script which builds jpy_ms.
# I use jpy_ms as a source of data for building SVM models:
sqt>jpy10.txt<<EOF
@jpy10.sql
EOF

date

# Build a SQL script full of calls to a set of scoring scipts:
sqt>scorem_out.txt<<EOF
@build_scorem.sql
EOF

# Massage the output txt into a sql script
grep score1_5min scorem_out.txt | grep -v SELECT > scorem.sql

exit

# Run scorem
sqt>out_of_scorem.txt<<EOF
@scorem.sql
EOF

date

exit
