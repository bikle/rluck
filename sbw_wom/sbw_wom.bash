#!/bin/bash

# sbw_wom.bash

# I use this script to load Forex data from the Fed and then run
# queries which help me look for correlation trends related to "Week of Month".

. /pt/s/oracle/.orcl

set -x

cd /pt/s/rlk/sbw_wom/

./wgetem.bash  > wgetem.txt  2>&1
./sqlldem.bash > sqlldem.txt 2>&1

sqt>merge_fxw.txt<<EOF
@merge_fxw.sql
EOF

sqt>qfs.txt<<EOF
@qfs.sql
EOF
