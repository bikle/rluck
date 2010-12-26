#!/bin/bash

# jpy_svm.bash

# Runs svm for a specific pair: jpy

. /pt/s/rluck/svm6/.orcl
. /pt/s/rluck/svm6/.jruby

set -x

cd $SVM6
cd svm/

# Build jpy6.sql
./bld_jpy6.bash

# Run script to build jpy_ms6
sqt>jpy6out.txt<<EOF
@jpy6.sql
EOF
# Look for errors
grep -i error jpy6out.txt | wc -l

# de_dup fxscores6, fxscores6_gattn
./de_dup_fx.bash


# Build script full of calls to scoring script
sqt>jpy_scorem.txt<<EOF
@jpy_build_scorem.sql
EOF

# Massage the output txt into a sql script
grep score1day jpy_scorem.txt | grep -v SELECT > jpy_scorem.sql

# Run scorem
sqt>out_of_jpy_scorem.txt<<EOF
@jpy_scorem.sql
EOF

# Look at recent scores
sqt<<EOF
@qry_recent_fxscores.sql
EOF

exit
