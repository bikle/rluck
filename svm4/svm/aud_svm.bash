#!/bin/bash

# aud_svm.bash

# Runs svm for a specific pair: aud

. /pt/s/rluck/svm4/.orcl
. /pt/s/rluck/svm4/.jruby

set -x

cd $SVM4
cd svm/

# Build aud4.sql
./bld_aud4.bash

# Run script to build aud_ms4
sqt>aud4out.txt<<EOF
@aud4.sql
EOF
# Look for errors
grep -i error aud4out.txt | wc -l

exit

# de_dup fxscores4, fxscores4_gattn
./de_dup_fx.bash


# Build script full of calls to scoring script
sqt>aud_scorem.txt<<EOF
@aud_build_scorem.sql
EOF

# Massage the output txt into a sql script
grep score1day aud_scorem.txt | grep -v SELECT > aud_scorem.sql

exit

# Run scorem
sqt>out_of_aud_scorem.txt<<EOF
@aud_scorem.sql
EOF

# Look at recent scores
sqt<<EOF
@qry_recent_fxscores.sql
EOF

exit
