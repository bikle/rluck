#!/bin/bash

# run1hr_data.bash

# This script helps me keep the table ibs1hr filled with recent data.

set -x

export myts=`date +%Y_%m_%d_%H_%M`

cd /pt/s/rluck/svmhstk/ibapi/

./1hr_data.bash SPY  > /pt/s/cron/out/1hr_data.${myts}.txt 2>&1
./1hr_data.bash QQQQ > /pt/s/cron/out/1hr_data.${myts}.txt 2>&1

exit

./1hr_data.bash DIA  > /pt/s/cron/out/1hr_data.${myts}.txt 2>&1
./1hr_data.bash DIS  > /pt/s/cron/out/1hr_data.${myts}.txt 2>&1
./1hr_data.bash GOOG > /pt/s/cron/out/1hr_data.${myts}.txt 2>&1
./1hr_data.bash WMT  > /pt/s/cron/out/1hr_data.${myts}.txt 2>&1
./1hr_data.bash XOM  > /pt/s/cron/out/1hr_data.${myts}.txt 2>&1
./1hr_data.bash EBAY > /pt/s/cron/out/1hr_data.${myts}.txt 2>&1
./1hr_data.bash HPQ  > /pt/s/cron/out/1hr_data.${myts}.txt 2>&1
./1hr_data.bash IBM  > /pt/s/cron/out/1hr_data.${myts}.txt 2>&1

exit
