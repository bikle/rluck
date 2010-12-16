#!/bin/bash

# place_order.bash

# I use this script to place orders with IB via their API.

. /pt/s/rluck/svm4hp/.orcl
. /pt/s/rluck/svm4hp/.jruby

set -x 
cd $SVM4HP
cd openclose/

echo jruby place_order.rb $@
