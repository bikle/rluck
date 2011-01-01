#!/bin/bash

# svmspy.bash

# I use this script as an entry point into my efforts to run SVM against stock data points separated by 5 minutes.

. /pt/s/rluck/svmspy/.orcl
. /pt/s/rluck/svmspy/.jruby

set -x

date

cd $SVMSPY

# Run a SQL script which builds stk_ms.
# I use stk_ms as a source of data for building SVM models:
sqt>spy10.txt<<EOF
@stk10.sql SPY
EOF

exit

date

# Build a SQL script full of calls to a set of scoring scipts:
sqt>scorem_SPY_out.txt<<EOF
@build_scorem.sql SPY
EOF

# Massage the output txt into a sql script
grep score1_5min scorem_SPY_out.txt | grep -v SELECT > scorem_spy.sql

# Run scorem_spy
sqt>out_of_scorem_spy.txt<<EOF
@scorem_spy.sql
EOF

date

exit
