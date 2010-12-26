#!/bin/bash

# eur_svm.bash

# Runs svm for a specific pair: eur

. /pt/s/rluck/svm6/.orcl
. /pt/s/rluck/svm6/.jruby

set -x

cd $SVM6
cd svm/

# Build eur6.sql
./bld_eur6.bash

# Run script to build eur_ms6
sqt>eur6out.txt<<EOF
@eur6.sql
EOF
# Look for errors
grep -i error eur6out.txt | wc -l

# de_dup fxscores6, fxscores6_gattn
./de_dup_fx.bash


# Build script full of calls to scoring script
sqt>eur_scorem.txt<<EOF
@eur_build_scorem.sql
EOF

# Massage the output txt into a sql script
grep score1day eur_scorem.txt | grep -v SELECT > eur_scorem.sql

# Run scorem
sqt>out_of_eur_scorem.txt<<EOF
@eur_scorem.sql
EOF

# Look at recent scores
sqt<<EOF
@qry_recent_fxscores.sql
EOF

exit
