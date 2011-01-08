#!/bin/bash

# run5min_data.bash

# This script helps me keep the table ibf5min filled with recent data.

set -x

# sleep for 15 min:
# sleep 915

export myts=`date +%Y_%m_%d_%H_%M`

cd /pt/s/rluck/svm6/ibapi/

./5min_data.bash > /pt/s/cron/out/5min_data.${myts}.txt 2>&1
