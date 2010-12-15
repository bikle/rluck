#!/bin/bash

# bld_run_big10.sql

# Edit copies of abc10.sql to make gbp10.sql, etc.

. /pt/s/rluck/svm4hp/.orcl
. /pt/s/rluck/svm4hp/.jruby

set -x

cd $SVM4HP
cd svm2/

cat abc10.sql | sed 's/abc/eur/g' > eur10.sql
cat abc10.sql | sed 's/abc/aud/g' > aud10.sql
cat abc10.sql | sed 's/abc/gbp/g' > gbp10.sql
cat abc10.sql | sed 's/abc/jpy/g' > jpy10.sql
cat abc10.sql | sed 's/abc/cad/g' > cad10.sql
cat abc10.sql | sed 's/abc/chf/g' > chf10.sql

cat \
eur10.sql \
aud10.sql \
gbp10.sql \
jpy10.sql \
cad10.sql \
chf10.sql \
|grep -v exit > big10.sql

sqt>out_of_big10.txt<<EOF
@big10.sql
EOF

# Look for errors
grep -i error out_of_big10.txt | wc -l
