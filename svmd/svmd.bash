#!/bin/bash

# svmd.bash

# I use this script as the nightly entry point for svmd.

. /pt/s/rluck/svmd/.orcl
. /pt/s/rluck/svmd/.jruby

cd $SVMD

# wgetem is fast so just get them all.
./wgetem.bash

# sqlloadem is fast too.
./sqlloadem.bash

# Run SVM against the good tkrs only.
#./good_svmtkr.bash 


# Run SVM against all the tkrs.
./many_svmtkr.bash 


exit 0

