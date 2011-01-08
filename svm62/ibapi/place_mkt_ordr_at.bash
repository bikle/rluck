#!/bin/bash

# place_mkt_ordr_at.bash

# I use this script to place orders with IB via their API.

# Usage: 
# place_mkt_ordr_at.bash buy|sell size SYMBOL CURRENCY gadate"
# Demo:
# place_mkt_ordr_at.bash sell 30000 EUR CHF 20101220_20:06:12_GMT

. /pt/s/rluck/svm62/.orcl
. /pt/s/rluck/svm62/.jruby

set -x 
cd $SVM62
cd ibapi/

echo jruby place_mkt_ordr_at.rb $@
## jruby --debug place_mkt_ordr_at.rb $@
jruby place_mkt_ordr_at.rb $@

exit
