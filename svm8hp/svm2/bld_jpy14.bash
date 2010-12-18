#!/bin/bash

# bld_jpy14.bash

# This script builds a sql script.

. /pt/s/rluck/svm8hp/.jruby

set -x

cd $SVM8HP
cd svm2/

# jpy14t.txt will be the 'top' of jpy14.sql
cat abc14t.txt | sed 's/abc/jpy/g' > jpy14t.txt

# jpy14m.txt will be the 'middle' of jpy14.sql
cat abcxyz.sql | sed 's/abc/jpy/g' | sed 's/xyz/eur/g' > jpy14m.txt
cat abcxyz.sql | sed 's/abc/jpy/g' | sed 's/xyz/aud/g' >> jpy14m.txt
cat abcxyz.sql | sed 's/abc/jpy/g' | sed 's/xyz/gbp/g' >> jpy14m.txt
cat abcxyz.sql | sed 's/abc/jpy/g' | sed 's/xyz/jpy/g' >> jpy14m.txt
cat abcxyz.sql | sed 's/abc/jpy/g' | sed 's/xyz/cad/g' >> jpy14m.txt
cat abcxyz.sql | sed 's/abc/jpy/g' | sed 's/xyz/chf/g' >> jpy14m.txt

# jpy14b.txt will be the 'bottom' of jpy14.sql
cat abc14b.txt | sed 's/abc/jpy/g' > jpy14b.txt

# cat together 
#   top,        middle,    bottom:
cat jpy14t.txt  jpy14m.txt jpy14b.txt > jpy14.sql
echo done with $0, jpy14.sql has been built from a top, middle, bottom set of text files.
