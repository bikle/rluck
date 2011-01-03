#!/bin/bash

# load5min.bash

# I use this script to load price data into ibf5min.

# Demo:
# 5min_data.bash SPY

if [ $# -ne 1 ]
then
  echo You need to give a tkr.
  echo Demo:
  echo $0 SPY
  exit 1
else

. /pt/s/rluck/svmspy/.jruby
. /pt/s/rluck/svmspy/.orcl

set -x

cd $SVMSPY/ibapi

cd csv_files/

# Loop through the CSV files belonging to $1:

sort ${1}* |uniq|grep 1|grep -v finished|awk -v awk_var=$1 -F, '{print awk_var","$2","$3}'> ibs_stage.csv

cd ..
rm -f ibs_stage.csv
ln -s csv_files/ibs_stage.csv .

sqt<<EOF
-- @cr_ibs_stage.sql
EOF

# call sqlloader
sqlldr trade/t bindsize=20971520 readsize=20971520 rows=123456 control=ibs_stage.ctl
grep loaded ibs_stage.log
wc -l ibs_stage.csv

sqt>merge.txt<<EOF
@merge.sql
EOF

export myts=`date +%Y_%m_%d_%H_%M`
cp -p ibs_stage.log ibs_stage_sqlldr.${myts}.log
cp -p merge.txt merge5min.${myts}.txt
mv merge5min.${myts}.txt ibs_stage_sqlldr.${myts}.log /pt/s/cron/out/

exit 0

# end of if [ $# -ne 1 ] #######
fi
# end of if [ $# -ne 1 ] #######

exit
