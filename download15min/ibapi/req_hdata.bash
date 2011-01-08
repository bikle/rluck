#!/bin/bash

# req_hdata.bash

# I use this to demo how to request historical data from IB.

. /pt/s/rluck/dl15/.jruby

set -x

cd /pt/s/rluck/dl15/ibapi/

jruby req_hdata.rb IBM

exit
