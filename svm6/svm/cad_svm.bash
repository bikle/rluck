#!/bin/bash

# cad_svm.bash

# Runs svm for a specific pair: cad

. /pt/s/rluck/svm6/.orcl
. /pt/s/rluck/svm6/.jruby

set -x

cd $SVM6
cd svm/

# Build cad6.sql
./bld_cad6.bash

# Run script to build cad_ms6
sqt>cad6out.txt<<EOF
@cad6.sql
EOF
# Look for errors
grep -i error cad6out.txt | wc -l

# de_dup fxscores6, fxscores6_gattn
./de_dup_fx.bash


# Build script full of calls to scoring script
sqt>cad_scorem.txt<<EOF
@cad_build_scorem.sql
EOF

# Massage the output txt into a sql script
grep score1day cad_scorem.txt | grep -v SELECT > cad_scorem.sql

# Run scorem
sqt>out_of_cad_scorem.txt<<EOF
@cad_scorem.sql
EOF

# Look at recent scores
sqt<<EOF
@qry_recent_fxscores.sql
EOF

exit
