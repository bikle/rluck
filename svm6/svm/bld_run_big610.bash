#!/bin/bash

# bld_run_big610.sql

# Edit copies of abc610.sql to make gbp610.sql, etc.

. /pt/s/rluck/svm6/.orcl
. /pt/s/rluck/svm6/.jruby

set -x

cd $SVM6
cd svm/

cat abc610.sql | sed 's/abc/eur/g' > eur610.sql
cat abc610.sql | sed 's/abc/aud/g' > aud610.sql
cat abc610.sql | sed 's/abc/gbp/g' > gbp610.sql
cat abc610.sql | sed 's/abc/jpy/g' > jpy610.sql
cat abc610.sql | sed 's/abc/cad/g' > cad610.sql
cat abc610.sql | sed 's/abc/chf/g' > chf610.sql

cat \
eur610.sql \
aud610.sql \
gbp610.sql \
jpy610.sql \
cad610.sql \
chf610.sql \
|grep -v exit > big610.sql

sqt>out_of_big610.txt<<EOF
@big610.sql
EOF

# Look for errors
grep -i error out_of_big610.txt | wc -l
