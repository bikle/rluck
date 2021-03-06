#!/bin/bash

# svmtkr.bash

# I use this script as an entry point into my efforts to run SVM against stock data.

if [ $# -eq 1 ]
then

. /pt/s/rluck/svmhstk/.orcl
. /pt/s/rluck/svmhstk/.jruby

set -x

date

cd $SVMHSTK

# Run a SQL script which builds stk_ms.
# I use stk_ms as a source of data for building SVM models:
sqt>tkr10.txt<<EOF
@stk10.sql $1
EOF

date

# Build a SQL script full of calls to a set of scoring scipts:
sqt>scorem_tkr_out.txt<<EOF
@build_scorem.sql $1
EOF

# Massage the output txt into a sql script
grep score1_1hr scorem_tkr_out.txt | grep -v SELECT > scorem_tkr.sql

# Run scorem_tkr
sqt>out_of_scorem_tkr.txt<<EOF
@scorem_tkr.sql
EOF

date

exit 0

else
  echo You need to give a tkr.
  echo Demo:
  echo $0 SPY
  exit 1
fi


