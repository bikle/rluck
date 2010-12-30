#!/bin/bash

# bld_egb6.bash

# This script builds a sql script.

. /pt/s/rluck/svm6/.jruby

set -x

cd $SVM6
cd svm/

# egb6t.txt will be the 'top' of egb6.sql
cat abc6t.txt | sed 's/abc/egb/g' > egb6t.txt

# egb6m.txt will be the 'middle' of egb6.sql
cat abcxyz.sql | sed 's/abc/egb/g' | sed 's/xyz/eur/g' > egb6m.txt
cat abcxyz.sql | sed 's/abc/egb/g' | sed 's/xyz/aud/g' >> egb6m.txt
cat abcxyz.sql | sed 's/abc/egb/g' | sed 's/xyz/gbp/g' >> egb6m.txt
cat abcxyz.sql | sed 's/abc/egb/g' | sed 's/xyz/jpy/g' >> egb6m.txt
cat abcxyz.sql | sed 's/abc/egb/g' | sed 's/xyz/cad/g' >> egb6m.txt
cat abcxyz.sql | sed 's/abc/egb/g' | sed 's/xyz/chf/g' >> egb6m.txt

# egb6b.txt will be the 'bottom' of egb6.sql
cat abc6b.txt | sed 's/abc/egb/g' > egb6b.txt

# cat together 
#   top,        middle,    bottom:
cat egb6t.txt  egb6m.txt egb6b.txt > egb6.sql
echo done with $0, egb6.sql has been built from a top, middle, bottom set of text files.
