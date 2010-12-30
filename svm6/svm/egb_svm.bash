#!/bin/bash

# egb_svm.bash

# Runs svm for a specific pair: egb

. /pt/s/rluck/svm6/.orcl
. /pt/s/rluck/svm6/.jruby

set -x

cd $SVM6
cd svm/

# Build egb6.sql
./bld_egb6.bash

# Run script to build egb_ms6
sqt>egb6out.txt<<EOF
@egb6.sql
EOF
# Look for errors
grep -i error egb6out.txt | wc -l

# de_dup fxscores6, fxscores6_gattn
./de_dup_fx.bash


# Build script full of calls to scoring script
sqt>egb_scorem.txt<<EOF
@egb_build_scorem.sql
EOF

# Massage the output txt into a sql script
grep score1day egb_scorem.txt | grep -v SELECT > egb_scorem.sql

# Run scorem
sqt>out_of_egb_scorem.txt<<EOF
@egb_scorem.sql
EOF

# Look at recent scores
sqt<<EOF
@qry_recent_fxscores.sql
EOF

exit
