#!/bin/bash

# run15min_data.bash

# This script helps me keep the table ibf15min filled with recent data.

set -x

# sleep for 15 min:
# sleep 915

export myts=`date +%Y_%m_%d_%H_%M`

cd /pt/s/rluck/svm6/ibapi/

./15min_data.bash > /pt/s/cron/out/15min_data.${myts}.txt 2>&1
