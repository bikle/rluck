#!/bin/bash

# svmpair.bash

# I use this script as an entry point into my efforts to run SVM against stock data points separated by 5 minutes.

if [ $# -eq 1 ]
then

set -x

date

# Run a SQL script which builds stk_ms.
# I use stk_ms as a source of data for building SVM models:
sqt>pair10.txt<<EOF
@pair10.sql $1
EOF

date

# Build a SQL script full of calls to a set of scoring scipts:
sqt>scorem_pair_out.txt<<EOF
@build_scorem.sql $1
EOF

# Massage the output txt into a sql script
grep score1_5min scorem_pair_out.txt | grep -v SELECT > scorem_pair.sql

sqt>out_of_scorem_pair.txt<<EOF
@scorem_pair.sql
EOF

date

exit 0

else
  echo You need to give a pair.
  echo Demo:
  echo $0 aud_usd
  exit 1
fi


