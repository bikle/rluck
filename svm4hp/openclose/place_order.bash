#!/bin/bash

# place_order.bash

# I use this script to place orders with IB via their API.

# Usage: 
# place_order.rb buy|sell size SYMBOL CURRENCY opendate closedate"
# Demo:
# place_order.bash buy 30000 USD JPY 20110216_20:06:12_GMT 20110217_00:06:12_GMT

. /pt/s/rluck/svm4hp/.orcl
. /pt/s/rluck/svm4hp/.jruby

set -x 
cd $SVM4HP
cd openclose/

echo jruby place_order.rb $@
## jruby --debug place_order.rb $@
jruby place_order.rb $@
