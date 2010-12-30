#!/bin/bash

# ech_svm.bash

# Runs svm for a specific pair: ech

. /pt/s/rluck/svm6/.orcl
. /pt/s/rluck/svm6/.jruby

set -x

cd $SVM6
cd svm/

# Build ech6.sql
./bld_ech6.bash

# Run script to build ech_ms6
sqt>ech6out.txt<<EOF
@ech6.sql
EOF
# Look for errors
grep -i error ech6out.txt | wc -l

# de_dup fxscores6, fxscores6_gattn
./de_dup_fx.bash


# Build script full of calls to scoring script
sqt>ech_scorem.txt<<EOF
@ech_build_scorem.sql
EOF

# Massage the output txt into a sql script
grep score1day ech_scorem.txt | grep -v SELECT > ech_scorem.sql

# Run scorem
sqt>out_of_ech_scorem.txt<<EOF
@ech_scorem.sql
EOF

# Look at recent scores
sqt<<EOF
@qry_recent_fxscores.sql
EOF

exit
