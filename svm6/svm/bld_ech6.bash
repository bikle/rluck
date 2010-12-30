#!/bin/bash

# bld_ech6.bash

# This script builds a sql script.

. /pt/s/rluck/svm6/.jruby

set -x

cd $SVM6
cd svm/

# ech6t.txt will be the 'top' of ech6.sql
cat abc6t.txt | sed 's/abc/ech/g' > ech6t.txt

# ech6m.txt will be the 'middle' of ech6.sql
cat abcxyz.sql | sed 's/abc/ech/g' | sed 's/xyz/eur/g' > ech6m.txt
cat abcxyz.sql | sed 's/abc/ech/g' | sed 's/xyz/aud/g' >> ech6m.txt
cat abcxyz.sql | sed 's/abc/ech/g' | sed 's/xyz/gbp/g' >> ech6m.txt
cat abcxyz.sql | sed 's/abc/ech/g' | sed 's/xyz/jpy/g' >> ech6m.txt
cat abcxyz.sql | sed 's/abc/ech/g' | sed 's/xyz/cad/g' >> ech6m.txt
cat abcxyz.sql | sed 's/abc/ech/g' | sed 's/xyz/chf/g' >> ech6m.txt

# ech6b.txt will be the 'bottom' of ech6.sql
cat abc6b.txt | sed 's/abc/ech/g' > ech6b.txt

# cat together 
#   top,        middle,    bottom:
cat ech6t.txt  ech6m.txt ech6b.txt > ech6.sql
echo done with $0, ech6.sql has been built from a top, middle, bottom set of text files.
