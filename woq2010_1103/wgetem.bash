#!/bin/bash

# /pt/s/rlk/sbw_woq/wgetem.bash

# I use this to download corex currency data from the Fed.

. /pt/s/oracle/.orcl

set -x

cd /pt/s/rlk/sbw_woq/

wget http://www.federalreserve.gov/releases/h10/hist/dat00_eu.txt
wget http://www.federalreserve.gov/releases/h10/hist/dat00_uk.txt
wget http://www.federalreserve.gov/releases/h10/hist/dat00_al.txt

wget http://www.federalreserve.gov/releases/h10/hist/dat00_ja.txt
wget http://www.federalreserve.gov/releases/h10/hist/dat00_ca.txt
wget http://www.federalreserve.gov/releases/h10/hist/dat00_sz.txt

