#!/bin/bash

# abc_svm2.bash

# Runs svm for a specific pair: abc

. /pt/s/rluck/svm4hp/.orcl
. /pt/s/rluck/svm4hp/.jruby

set -x

cd $SVM4HP
cd svm2/

# Build abc14.sql
./bld_abc14.bash

# Run script to build abc_ms14
sqt>out2abc.txt<<EOF
@abc14.sql
EOF
# Look for errors
grep -i error out2abc.txt | wc -l

# Build script full of calls to scoring script
sqt>abc_scorem.txt<<EOF
@abc_build_scorem.sql
EOF

# Massage the output txt into a sql script
grep score1day abc_scorem.txt | grep -v SELECT > abc_scorem.sql

# Run scorem
sqt>out_of_abc_scorem.txt<<EOF
@abc_scorem.sql
EOF

# act on the scores:

cd $SVM4HP
cd openclose/
./oc.bash  > /pt/s/cron/out/oc.bash.${myts}.txt 2>&1

exit
