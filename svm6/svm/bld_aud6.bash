#!/bin/bash

# bld_aud6.bash

# This script builds a sql script.

. /pt/s/rluck/svm6/.jruby

set -x

cd $SVM6
cd svm/

# aud6t.txt will be the 'top' of aud6.sql
cat abc6t.txt | sed 's/abc/aud/g' > aud6t.txt

# aud6m.txt will be the 'middle' of aud6.sql
cat abcxyz.sql | sed 's/abc/aud/g' | sed 's/xyz/eur/g' > aud6m.txt
cat abcxyz.sql | sed 's/abc/aud/g' | sed 's/xyz/aud/g' >> aud6m.txt
cat abcxyz.sql | sed 's/abc/aud/g' | sed 's/xyz/gbp/g' >> aud6m.txt
cat abcxyz.sql | sed 's/abc/aud/g' | sed 's/xyz/jpy/g' >> aud6m.txt
cat abcxyz.sql | sed 's/abc/aud/g' | sed 's/xyz/cad/g' >> aud6m.txt
cat abcxyz.sql | sed 's/abc/aud/g' | sed 's/xyz/chf/g' >> aud6m.txt

# aud6b.txt will be the 'bottom' of aud6.sql
cat abc6b.txt | sed 's/abc/aud/g' > aud6b.txt

# cat together 
#   top,        middle,    bottom:
cat aud6t.txt  aud6m.txt aud6b.txt > aud6.sql
echo done with $0, aud6.sql has been built from a top, middle, bottom set of text files.
