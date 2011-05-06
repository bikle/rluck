#!/bin/bash

# update_di5min_stk.bash

. /pt/s/rluck/svmspy/.orcl
. /pt/s/rluck/svmspy/.jruby

set -x

cd $SVMSPY/ibapi

sqt>update_di5min_stk.txt<<EOF
@update_di5min_stk.sql
EOF




