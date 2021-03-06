#!/bin/bash

. /pt/s/rluck/svm8hp/.orcl
. /pt/s/rluck/svm8hp/.jruby

set -x

cd $SVM8HP
cd svm2/

# Build aud14.sql
./bld_aud14.bash

# Run script to build aud_ms14
sqt>out2aud.txt<<EOF
@aud14.sql
EOF
# Look for errors
grep -i error out2aud.txt | wc -l

# Build script full of calls to scoring script
sqt>aud_scorem.txt<<EOF
@my_build_scorem.sql
EOF

# Massage the output txt into a sql script
grep score1day aud_scorem.txt | grep -v SELECT > aud_scorem.sql
cat  aud_scorem.txt

exit

# Run scorem
sqt>out_of_aud_scorem.txt<<EOF
@aud_scorem.sql
EOF

exit

# Look at recent scores
sqt<<EOF
@qry_recent_fxscores.sql
EOF

exit
