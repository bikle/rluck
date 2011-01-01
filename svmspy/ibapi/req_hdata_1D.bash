#!/bin/bash

# req_hdata_1D.bash

# I use this to request historical data from IB.

. /pt/s/oracle/.jruby

set -x

cd /pt/s/rluck/svm6/ibapi/

jruby --debug req_hdata_1D.rb EUR USD

exit
