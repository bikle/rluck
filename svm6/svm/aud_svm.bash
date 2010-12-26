#!/bin/bash

# aud_svm.bash

# Runs svm for a specific pair: aud

. /pt/s/rluck/svm6/.orcl
. /pt/s/rluck/svm6/.jruby

set -x

cd $SVM6
cd svm/

# Build aud6.sql
./bld_aud6.bash

# Run script to build aud_ms6
sqt>aud6out.txt<<EOF
@aud6.sql
EOF
# Look for errors
grep -i error aud6out.txt | wc -l

# de_dup fxscores6, fxscores6_gattn
./de_dup_fx.bash


# Build script full of calls to scoring script
sqt>aud_scorem.txt<<EOF
@aud_build_scorem.sql
EOF

# Massage the output txt into a sql script
grep score1day aud_scorem.txt | grep -v SELECT > aud_scorem.sql

# Run scorem
sqt>out_of_aud_scorem.txt<<EOF
@aud_scorem.sql
EOF

# Look at recent scores
sqt<<EOF
@qry_recent_fxscores.sql
EOF

exit
