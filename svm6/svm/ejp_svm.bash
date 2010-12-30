#!/bin/bash

# ejp_svm.bash

# Runs svm for a specific pair: ejp

. /pt/s/rluck/svm6/.orcl
. /pt/s/rluck/svm6/.jruby

set -x

cd $SVM6
cd svm/

# Build ejp6.sql
./bld_ejp6.bash

# Run script to build ejp_ms6
sqt>ejp6out.txt<<EOF
@ejp6.sql
EOF
# Look for errors
grep -i error ejp6out.txt | wc -l

# de_dup fxscores6, fxscores6_gattn
./de_dup_fx.bash


# Build script full of calls to scoring script
sqt>ejp_scorem.txt<<EOF
@ejp_build_scorem.sql
EOF

# Massage the output txt into a sql script
grep score1day ejp_scorem.txt | grep -v SELECT > ejp_scorem.sql

# Run scorem
sqt>out_of_ejp_scorem.txt<<EOF
@ejp_scorem.sql
EOF

# Look at recent scores
sqt<<EOF
@qry_recent_fxscores.sql
EOF

exit
