#!/bin/bash

# load_tkr_1hr.bash

# Demo: load_tkr_1hr.bash SPY

# I use this script as a wrapper for sqlldr.
# This script is called from cmd line, not another script.

if [ $# -eq 1 ]
then

. /pt/s/rluck/svmhstk/.orcl
. /pt/s/rluck/svmhstk/.jruby

set -x

cd $SVMHSTK/dukas/

# Create table hstage
sqt<<EOF
DROP TABLE hstage;
PURGE RECYCLEBIN;
CREATE TABLE hstage (ydate VARCHAR2(10), ttime VARCHAR2(9), vol NUMBER, opn NUMBER, clse NUMBER, mn NUMBER, mx NUMBER);
EOF

# Prep hstage.1hr.csv
touch ${1}.1hr.csv
mv    ${1}*.1hr.csv data/
cd data/
sort ${1}*.1hr.csv |uniq|grep 1|grep -v DATE > hstage.1hr.csv

cd ..
rm -f hstage.csv
# hstage.ctl wants hstage.csv:
ln -s data/hstage.1hr.csv hstage.csv

# call sqlloader
sqlldr trade/t bindsize=20971520 readsize=20971520 rows=123456 control=hstage.ctl
grep loaded hstage.log
wc -l hstage.csv

# Merge hstage into dukas1hr
sqt<<EOF
@merge_dukas1hr_stk.sql  $1
EOF

else
  echo You need to give a tkr to this script.
  echo Demo: $0 SPY
  exit 1
fi

exit 0
