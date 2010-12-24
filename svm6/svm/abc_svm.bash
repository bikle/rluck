#!/bin/bash

# abc_svm.bash

# Runs svm for a specific pair: abc

. /pt/s/rluck/svm6/.orcl
. /pt/s/rluck/svm6/.jruby

set -x

cd $SVM6
cd svm/

# Build abc6.sql
./bld_abc6.bash

# Run script to build abc_ms6
sqt>out2abc.txt<<EOF
@abc6.sql
EOF
# Look for errors
grep -i error out2abc.txt | wc -l

# de_dup fxscores6, fxscores6_gattn
./de_dup_fx.bash

# Build script full of calls to scoring script
sqt>abc_scorem.txt<<EOF
@abc_build_scorem.sql
EOF

# Massage the output txt into a sql script
grep score1day abc_scorem.txt | grep -v SELECT > abc_scorem.sql
cat  abc_scorem.txt

# Run scorem
sqt>out_of_abc_scorem.txt<<EOF
@abc_scorem.sql
EOF

# Look at recent scores
sqt<<EOF
@qry_recent_fxscores.sql
EOF

exit
