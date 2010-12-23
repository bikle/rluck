#!/bin/bash

# gbp_svm2.bash

# Runs svm for a specific pair: gbp

. /pt/s/rluck/svm8hp/.orcl
. /pt/s/rluck/svm8hp/.jruby

set -x

cd $SVM8HP
cd svm2/

# Build gbp14.sql
./bld_gbp14.bash

# Run script to build gbp_ms14
sqt>out2gbp.txt<<EOF
@gbp14.sql
EOF
# Look for errors
grep -i error out2gbp.txt | wc -l

# de_dup fxscores8hp, fxscores8hp_gattn
./de_dup_fx.bash

# Build script full of calls to scoring script
sqt>gbp_scorem.txt<<EOF
@gbp_build_scorem.sql
EOF

# Massage the output txt into a sql script
grep score1day gbp_scorem.txt | grep -v SELECT > gbp_scorem.sql
cat  gbp_scorem.txt

# Run scorem
sqt>out_of_gbp_scorem.txt<<EOF
@gbp_scorem.sql
EOF

# Look at recent scores
sqt<<EOF
@qry_recent_fxscores.sql
EOF

exit
