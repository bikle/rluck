#!/bin/bash

# chf_svm.bash

# Runs svm for a specific pair: chf

. /pt/s/rluck/svm6/.orcl
. /pt/s/rluck/svm6/.jruby

set -x

cd $SVM6
cd svm/

# Build chf6.sql
./bld_chf6.bash

# Run script to build chf_ms6
sqt>chf6out.txt<<EOF
@chf6.sql
EOF
# Look for errors
grep -i error chf6out.txt | wc -l

# de_dup fxscores6, fxscores6_gattn
./de_dup_fx.bash


# Build script full of calls to scoring script
sqt>chf_scorem.txt<<EOF
@chf_build_scorem.sql
EOF

# Massage the output txt into a sql script
grep score1day chf_scorem.txt | grep -v SELECT > chf_scorem.sql

# Run scorem
sqt>out_of_chf_scorem.txt<<EOF
@chf_scorem.sql
EOF

# Look at recent scores
sqt<<EOF
@qry_recent_fxscores.sql
EOF

exit
