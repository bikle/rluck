#!/bin/bash

. /pt/s/rluck/svm4/.orcl
. /pt/s/rluck/svm4/.jruby

cd $SVM4
cd svm/

# Build script full of calls to scoring script
sqt>aud_scorem.txt<<EOF
@my_build_scorem.sql
EOF

# Massage the output txt into a sql script
grep score1day aud_scorem.txt | grep -v SELECT > aud_scorem.sql

exit

# Run scorem
sqt>out_of_aud_scorem.txt<<EOF
@aud_scorem.sql
EOF
