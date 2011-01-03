#!/bin/bash

# req_hdata_several.bash


. /pt/s/rluck/svmhstk/.jruby
. /pt/s/rluck/svmhstk/.orcl


cd $SVMHSTK/ibapi

# jruby req_hdata_1D.rb SPY
jruby req_hdata_1D.rb QQQQ
jruby req_hdata_1D.rb DIA
jruby req_hdata_1D.rb DIS
jruby req_hdata_1D.rb GOOG
jruby req_hdata_1D.rb WMT
jruby req_hdata_1D.rb XOM
jruby req_hdata_1D.rb EBAY
jruby req_hdata_1D.rb HPQ
jruby req_hdata_1D.rb IBM

