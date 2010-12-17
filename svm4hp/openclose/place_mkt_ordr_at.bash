#!/bin/bash

# place_mkt_ordr_at.bash

# I use this script to place orders with IB via their API.

# Usage: 
# place_mkt_ordr_at.bash buy|sell size SYMBOL CURRENCY gadate"
# Demo:
# place_mkt_ordr_at.bash buy 30000 USD JPY 20110216_20:06:12_GMT

. /pt/s/rluck/svm4hp/.orcl
. /pt/s/rluck/svm4hp/.jruby

set -x 
cd $SVM4HP
cd openclose/

echo jruby place_mkt_ordr_at.rb $@
## jruby --debug place_mkt_ordr_at.rb $@
jruby place_mkt_ordr_at.rb $@
