#!/bin/bash

# bld_chf6.bash

# This script builds a sql script.

. /pt/s/rluck/svm6/.jruby

set -x

cd $SVM6
cd svm/

# chf6t.txt will be the 'top' of chf6.sql
cat abc6t.txt | sed 's/abc/chf/g' > chf6t.txt

# chf6m.txt will be the 'middle' of chf6.sql
cat abcxyz.sql | sed 's/abc/chf/g' | sed 's/xyz/eur/g' > chf6m.txt
cat abcxyz.sql | sed 's/abc/chf/g' | sed 's/xyz/aud/g' >> chf6m.txt
cat abcxyz.sql | sed 's/abc/chf/g' | sed 's/xyz/gbp/g' >> chf6m.txt
cat abcxyz.sql | sed 's/abc/chf/g' | sed 's/xyz/jpy/g' >> chf6m.txt
cat abcxyz.sql | sed 's/abc/chf/g' | sed 's/xyz/cad/g' >> chf6m.txt
cat abcxyz.sql | sed 's/abc/chf/g' | sed 's/xyz/chf/g' >> chf6m.txt

# chf6b.txt will be the 'bottom' of chf6.sql
cat abc6b.txt | sed 's/abc/chf/g' > chf6b.txt

# cat together 
#   top,        middle,    bottom:
cat chf6t.txt  chf6m.txt chf6b.txt > chf6.sql
echo done with $0, chf6.sql has been built from a top, middle, bottom set of text files.
