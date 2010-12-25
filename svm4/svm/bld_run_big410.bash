#!/bin/bash

# bld_run_big410.sql

# Edit copies of abc410.sql to make gbp410.sql, etc.

. /pt/s/rluck/svm4/.orcl
. /pt/s/rluck/svm4/.jruby

set -x

cd $SVM4
cd svm/

cat abc410.sql | sed 's/abc/eur/g' > eur410.sql
cat abc410.sql | sed 's/abc/aud/g' > aud410.sql
cat abc410.sql | sed 's/abc/gbp/g' > gbp410.sql
cat abc410.sql | sed 's/abc/jpy/g' > jpy410.sql
cat abc410.sql | sed 's/abc/cad/g' > cad410.sql
cat abc410.sql | sed 's/abc/chf/g' > chf410.sql

cat \
eur410.sql \
aud410.sql \
gbp410.sql \
jpy410.sql \
cad410.sql \
chf410.sql \
|grep -v exit > big410.sql

sqt>out_of_big410.txt<<EOF
@big410.sql
EOF

# Look for errors
grep -i error out_of_big410.txt | wc -l
