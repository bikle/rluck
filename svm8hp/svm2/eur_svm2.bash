#!/bin/bash

# eur_svm2.bash

# Runs svm for a specific pair: eur

. /pt/s/rluck/svm8hp/.orcl
. /pt/s/rluck/svm8hp/.jruby

set -x

cd $SVM8HP
cd svm2/

# Build eur14.sql
./bld_eur14.bash

# Run script to build eur_ms14
sqt>out2eur.txt<<EOF
@eur14.sql
EOF
# Look for errors
grep -i error out2eur.txt | wc -l

# Build script full of calls to scoring script
sqt>eur_scorem.txt<<EOF
@eur_build_scorem.sql
EOF

# Massage the output txt into a sql script
grep score1day eur_scorem.txt | grep -v SELECT > eur_scorem.sql
cat  eur_scorem.txt

# Run scorem
sqt>out_of_eur_scorem.txt<<EOF
@eur_scorem.sql
EOF

exit
