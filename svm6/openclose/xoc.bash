#!/bin/bash

# xoc.bash

# I use this script to help me execute open/close orders.

. /pt/s/rluck/svm6/.orcl
. /pt/s/rluck/svm6/.jruby

set -x 
cd $SVM6
cd openclose/

sqt>xoc.txt<<EOF
@xoc.sql
EOF

export myts=`date +%Y_%m_%d_%H_%M`
cp -p xoc.txt /pt/s/cron/out/xoc.${myts}.txt

grep place_order.bash xoc.txt | grep -v shell_cmd > an_order.bash
chmod +x an_order.bash
cat ./an_order.bash
mv  ./an_order.bash ../ibapi/
cd ../ibapi/
# Not yet:
./an_order.bash

exit

