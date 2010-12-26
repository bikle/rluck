#!/bin/bash

# bld_cad6.bash

# This script builds a sql script.

. /pt/s/rluck/svm6/.jruby

set -x

cd $SVM6
cd svm/

# cad6t.txt will be the 'top' of cad6.sql
cat abc6t.txt | sed 's/abc/cad/g' > cad6t.txt

# cad6m.txt will be the 'middle' of cad6.sql
cat abcxyz.sql | sed 's/abc/cad/g' | sed 's/xyz/eur/g' > cad6m.txt
cat abcxyz.sql | sed 's/abc/cad/g' | sed 's/xyz/aud/g' >> cad6m.txt
cat abcxyz.sql | sed 's/abc/cad/g' | sed 's/xyz/gbp/g' >> cad6m.txt
cat abcxyz.sql | sed 's/abc/cad/g' | sed 's/xyz/jpy/g' >> cad6m.txt
cat abcxyz.sql | sed 's/abc/cad/g' | sed 's/xyz/cad/g' >> cad6m.txt
cat abcxyz.sql | sed 's/abc/cad/g' | sed 's/xyz/chf/g' >> cad6m.txt

# cad6b.txt will be the 'bottom' of cad6.sql
cat abc6b.txt | sed 's/abc/cad/g' > cad6b.txt

# cat together 
#   top,        middle,    bottom:
cat cad6t.txt  cad6m.txt cad6b.txt > cad6.sql
echo done with $0, cad6.sql has been built from a top, middle, bottom set of text files.
