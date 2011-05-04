#!/bin/bash

# svmd.bash

# I use this script as the nightly entry point for svmd.

. /pt/s/rluck/svmd/.orcl
. /pt/s/rluck/svmd/.jruby

cd $SVMD

./wgetem.bash

./sqlloadem.bash

exit

./many_svmtkr.bash

exit 0

