#!/bin/bash

# load1hr.bash

# I use this script to load data from CSV files into table, ibs1hr.
# I call this script from: 1hr_data.bash


# Demo:
# ./load1hr.bash SPY

if [ $# -ne 1 ]
then
  echo You need to give a tkr.
  echo Demo:
  echo $0 SPY
  exit 1
else

. /pt/s/rluck/svmhstk/.jruby
. /pt/s/rluck/svmhstk/.orcl

set -x

cd $SVMHSTK/ibapi/csv_files/

# Loop through the CSV files belonging to $1:
touch ${1}.csv
sort ${1}*csv |uniq|grep 1|grep -v finished|grep W|awk -v awk_var=$1 -F, '{print awk_var","$2","$3}'> ibs_stage.csv

cd ..
rm -f ibs_stage.csv
ln -s csv_files/ibs_stage.csv .

sqt<<EOF
-- @cr_ibs_stage.sql
EOF

# call sqlldr
sqlldr trade/t bindsize=20971520 readsize=20971520 rows=123456 control=ibs_stage.ctl
grep loaded ibs_stage.log
wc -l ibs_stage.csv

sqt>merge.txt<<EOF
@merge.sql
EOF

export myts=`date +%Y_%m_%d_%H_%M`
cp -p ibs_stage.log ibs_stage_sqlldr.${myts}.log
cp -p merge.txt merge1hr.${myts}.txt
mv merge1hr.${myts}.txt ibs_stage_sqlldr.${myts}.log /pt/s/cron/out/


# end of if ########
fi
# end of if ########

exit 0
