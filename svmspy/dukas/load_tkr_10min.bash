#!/bin/bash

# load_tkr_10min.bash

# Demo: load_tkr_10min.bash SPY

if [ $# -eq 1 ]
then

. /pt/s/rluck/svmspy/.orcl
. /pt/s/rluck/svmspy/.jruby

set -x

cd $SVMSPY/dukas/

# Create table hstage
sqt<<EOF
DROP TABLE hstage;
PURGE RECYCLEBIN;
CREATE TABLE hstage (ydate VARCHAR2(10), ttime VARCHAR2(9), vol NUMBER, opn NUMBER, clse NUMBER, mn NUMBER, mx NUMBER);
EOF

# Prep hstage.10min.csv
touch ${1}.10min.csv
mv    ${1}*.10min.csv data/
cd data/
sort ${1}*.10min.csv |uniq|grep 1|grep -v DATE > hstage.10min.csv

cd ..
rm -f hstage.csv
# hstage.ctl wants hstage.csv:
ln -s data/hstage.10min.csv hstage.csv

# call sqlloader
sqlldr trade/t bindsize=20971520 readsize=20971520 rows=123456 control=hstage.ctl
grep loaded hstage.log
wc -l hstage.csv

# Merge hstage into dukas10min
sqt<<EOF
@merge_dukas10min_stk.sql  $1
EOF

exit 0

else
  echo You need to give a tkr to this script.
  echo Demo: $0 SPY
fi

exit
