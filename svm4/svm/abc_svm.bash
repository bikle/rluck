#!/bin/bash

# abc_svm.bash

# Runs svm for a specific pair: abc

. /pt/s/rluck/svm4/.orcl
. /pt/s/rluck/svm4/.jruby

set -x

cd $SVM4
cd svm/

# Build abc4.sql
./bld_abc4.bash

# Run script to build abc_ms4
sqt>abc4out.txt<<EOF
@abc4.sql
EOF
# Look for errors
grep -i error abc4out.txt | wc -l

# de_dup fxscores4, fxscores4_gattn
./de_dup_fx.bash


# Build script full of calls to scoring script
sqt>abc_scorem.txt<<EOF
@abc_build_scorem.sql
EOF

# Massage the output txt into a sql script
grep score1day abc_scorem.txt | grep -v SELECT > abc_scorem.sql

exit

# Run scorem
sqt>out_of_abc_scorem.txt<<EOF
@abc_scorem.sql
EOF

# Look at recent scores
sqt<<EOF
@qry_recent_fxscores.sql
EOF

exit
