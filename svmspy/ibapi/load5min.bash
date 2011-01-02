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

# Loop through the CSV files.

sort ${1}* |uniq|grep 1|grep -v finished|awk -v awk_var=$1 -F, '{print awk_var","$2","$3}'> ibs_stage.csv

exit 0

# end of if [ $# -ne 1 ] #######
fi
# end of if [ $# -ne 1 ] #######



exit

sort AUD_USD* |uniq|grep 1|grep -v finished|awk -F, '{print "aud_usd,"$2","$3}'> ibf_stage.csv
sort EUR_USD* |uniq|grep 1|grep -v finished|awk -F, '{print "eur_usd,"$2","$3}'>> ibf_stage.csv
sort GBP_USD* |uniq|grep 1|grep -v finished|awk -F, '{print "gbp_usd,"$2","$3}'>> ibf_stage.csv
sort USD_JPY* |uniq|grep 1|grep -v finished|awk -F, '{print "usd_jpy,"$2","$3}'>> ibf_stage.csv
sort USD_CAD* |uniq|grep 1|grep -v finished|awk -F, '{print "usd_cad,"$2","$3}'>> ibf_stage.csv
sort USD_CHF* |uniq|grep 1|grep -v finished|awk -F, '{print "usd_chf,"$2","$3}'>> ibf_stage.csv

cd ..
rm -f ibf_stage.csv
ln -s csv_files/ibf_stage.csv .

sqt<<EOF
-- @cr_ibf_stage.sql
EOF

# call sqlloader
sqlldr trade/t bindsize=20971520 readsize=20971520 rows=123456 control=ibf_stage.ctl
grep loaded ibf_stage.log
wc -l ibf_stage.csv

sqt>qry_ibf_stage.txt<<EOF
-- @qry_ibf_stage.sql
EOF

sqt>merge.txt<<EOF
@merge.sql
EOF

export myts=`date +%Y_%m_%d_%H_%M`
cp -p ibf_stage.log ibf_stage_sqlldr.${myts}.log
cp -p merge.txt merge5min.${myts}.txt
mv merge5min.${myts}.txt ibf_stage_sqlldr.${myts}.log /pt/s/cron/out/

exit
