#!/bin/bash

#s qlldem.bash

# This is a wrapper script for sql loader.

. /pt/s/oracle/.orcl

set -x

cat dat00_al.txt|sed '1,$s/.$//' |awk '{print $1","$2",aud_usd"}' |grep '^[0-9]'|grep -v ND >fxw_stage.csv
cat dat00_eu.txt|sed '1,$s/.$//' |awk '{print $1","$2",eur_usd"}' |grep '^[0-9]'|grep -v ND >>fxw_stage.csv
cat dat00_uk.txt|sed '1,$s/.$//' |awk '{print $1","$2",gbp_usd"}' |grep '^[0-9]'|grep -v ND >>fxw_stage.csv
cat dat00_ja.txt|sed '1,$s/.$//' |awk '{print $1","$2",usd_jpy"}' |grep '^[0-9]'|grep -v ND >>fxw_stage.csv
cat dat00_ca.txt|sed '1,$s/.$//' |awk '{print $1","$2",usd_cad"}' |grep '^[0-9]'|grep -v ND >>fxw_stage.csv
cat dat00_sz.txt|sed '1,$s/.$//' |awk '{print $1","$2",usd_chf"}' |grep '^[0-9]'|grep -v ND >>fxw_stage.csv

sqlldr trade/t control=fxw_stage.ctl bindsize=20971520 readsize=20971520 rows=123456
grep loaded fxw_stage.log
wc -l fxw_stage.csv

