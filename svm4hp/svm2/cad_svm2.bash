#!/bin/bash

# cad_svm2.bash

# Runs svm for a specific pair: cad

. /pt/s/rluck/svm4hp/.orcl
. /pt/s/rluck/svm4hp/.jruby

set -x

cd $SVM4HP
cd svm2/

# Build cad14.sql
./bld_cad14.bash

# Run script to build cad_ms14
sqt>out2cad.txt<<EOF
@cad14.sql
EOF
# Look for errors
grep -i error out2cad.txt | wc -l

# Build script full of calls to scoring script
sqt>cad_scorem.txt<<EOF
@cad_build_scorem.sql
EOF

# Massage the output txt into a sql script
grep score1day cad_scorem.txt | grep -v SELECT > cad_scorem.sql

# Run scorem
sqt>out_of_cad_scorem.txt<<EOF
@cad_scorem.sql
EOF
