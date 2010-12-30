#!/bin/bash

# ajp_svm.bash

# Runs svm for a specific pair: ajp

. /pt/s/rluck/svm6/.orcl
. /pt/s/rluck/svm6/.jruby

set -x

cd $SVM6
cd svm/

# Build ajp6.sql
./bld_ajp6.bash

# Run script to build ajp_ms6
sqt>ajp6out.txt<<EOF
@ajp6.sql
EOF
# Look for errors
grep -i error ajp6out.txt | wc -l

# de_dup fxscores6, fxscores6_gattn
./de_dup_fx.bash


# Build script full of calls to scoring script
sqt>ajp_scorem.txt<<EOF
@ajp_build_scorem.sql
EOF

# Massage the output txt into a sql script
grep score1day ajp_scorem.txt | grep -v SELECT > ajp_scorem.sql

# Run scorem
sqt>out_of_ajp_scorem.txt<<EOF
@ajp_scorem.sql
EOF

# Look at recent scores
sqt<<EOF
@qry_recent_fxscores.sql
EOF

exit
