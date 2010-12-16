#!/bin/bash

# xoc.bash

# I use this script to help me execute open/close orders.

. /pt/s/rluck/svm4hp/.orcl
. /pt/s/rluck/svm4hp/.jruby

set -x 
cd $SVM4HP
cd openclose/

sqt>xoc.txt<<EOF
@xoc.sql
EOF

grep place_order.bash xoc.txt | grep -v shell_cmd > an_order.bash
chmod +x an_order.bash
cat ./an_order.bash
# not yet: ./an_order.bash

exit

