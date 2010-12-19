#!/bin/bash

# chf_svm2.bash

# Runs svm for a specific pair: chf

. /pt/s/rluck/svm4hp/.orcl
. /pt/s/rluck/svm4hp/.jruby

set -x

cd $SVM4HP
cd svm2/

# Build chf14.sql
./bld_chf14.bash

# Run script to build chf_ms14
sqt>out2chf.txt<<EOF
@chf14.sql
EOF
# Look for errors
grep -i error out2chf.txt | wc -l

# Build script full of calls to scoring script
sqt>chf_scorem.txt<<EOF
@chf_build_scorem.sql
EOF

# Massage the output txt into a sql script
grep score1day chf_scorem.txt | grep -v SELECT > chf_scorem.sql

exit

# Run scorem
sqt>out_of_chf_scorem.txt<<EOF
@chf_scorem.sql
EOF
