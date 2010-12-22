#!/bin/bash

# jpy_svm2.bash

# Runs svm for a specific pair: jpy

. /pt/s/rluck/svm8hp/.orcl
. /pt/s/rluck/svm8hp/.jruby

set -x

cd $SVM8HP
cd svm2/

# Build jpy14.sql
./bld_jpy14.bash

# Run script to build jpy_ms14
sqt>out2jpy.txt<<EOF
@jpy14.sql
EOF
# Look for errors
grep -i error out2jpy.txt | wc -l

# Build script full of calls to scoring script
sqt>jpy_scorem.txt<<EOF
@jpy_build_scorem.sql
EOF

# Massage the output txt into a sql script
grep score1day jpy_scorem.txt | grep -v SELECT > jpy_scorem.sql
cat  jpy_scorem.txt

# Run scorem
sqt>out_of_jpy_scorem.txt<<EOF
@jpy_scorem.sql
EOF

# Look at recent scores
sqt<<EOF
@qry_recent_fxscores.sql
EOF

exit
