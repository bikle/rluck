#!/bin/bash

# bld_jpy6.bash

# This script builds a sql script.

. /pt/s/rluck/svm6/.jruby

set -x

cd $SVM6
cd svm/

# jpy6t.txt will be the 'top' of jpy6.sql
cat abc6t.txt | sed 's/abc/jpy/g' > jpy6t.txt

# jpy6m.txt will be the 'middle' of jpy6.sql
cat abcxyz.sql | sed 's/abc/jpy/g' | sed 's/xyz/eur/g' > jpy6m.txt
cat abcxyz.sql | sed 's/abc/jpy/g' | sed 's/xyz/aud/g' >> jpy6m.txt
cat abcxyz.sql | sed 's/abc/jpy/g' | sed 's/xyz/gbp/g' >> jpy6m.txt
cat abcxyz.sql | sed 's/abc/jpy/g' | sed 's/xyz/jpy/g' >> jpy6m.txt
cat abcxyz.sql | sed 's/abc/jpy/g' | sed 's/xyz/cad/g' >> jpy6m.txt
cat abcxyz.sql | sed 's/abc/jpy/g' | sed 's/xyz/chf/g' >> jpy6m.txt

# jpy6b.txt will be the 'bottom' of jpy6.sql
cat abc6b.txt | sed 's/abc/jpy/g' > jpy6b.txt

# cat together 
#   top,        middle,    bottom:
cat jpy6t.txt  jpy6m.txt jpy6b.txt > jpy6.sql
echo done with $0, jpy6.sql has been built from a top, middle, bottom set of text files.
