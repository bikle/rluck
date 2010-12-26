#!/bin/bash

# gbp_svm.bash

# Runs svm for a specific pair: gbp

. /pt/s/rluck/svm6/.orcl
. /pt/s/rluck/svm6/.jruby

set -x

cd $SVM6
cd svm/

# Build gbp6.sql
./bld_gbp6.bash

# Run script to build gbp_ms6
sqt>gbp6out.txt<<EOF
@gbp6.sql
EOF
# Look for errors
grep -i error gbp6out.txt | wc -l

# de_dup fxscores6, fxscores6_gattn
./de_dup_fx.bash


# Build script full of calls to scoring script
sqt>gbp_scorem.txt<<EOF
@gbp_build_scorem.sql
EOF

# Massage the output txt into a sql script
grep score1day gbp_scorem.txt | grep -v SELECT > gbp_scorem.sql

# Run scorem
sqt>out_of_gbp_scorem.txt<<EOF
@gbp_scorem.sql
EOF

# Look at recent scores
sqt<<EOF
@qry_recent_fxscores.sql
EOF

exit
