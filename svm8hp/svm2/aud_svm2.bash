#!/bin/bash

# aud_svm2.bash

# Runs svm for a specific pair: aud

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

# de_dup fxscores8hp, fxscores8hp_gattn
./de_dup_fx.bash

# Build script full of calls to scoring script
sqt>aud_scorem.txt<<EOF
@aud_build_scorem.sql
EOF

# Massage the output txt into a sql script
grep score1day aud_scorem.txt | grep -v SELECT > aud_scorem.sql
cat  aud_scorem.txt

# Run scorem
sqt>out_of_aud_scorem.txt<<EOF
@aud_scorem.sql
EOF

# Look at recent scores
sqt<<EOF
@qry_recent_fxscores.sql
EOF

exit
