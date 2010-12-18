#!/bin/bash

# bld_cad14.bash

# This script builds a sql script.

. /pt/s/rluck/svm8hp/.jruby

set -x

cd $SVM8HP
cd svm2/

# cad14t.txt will be the 'top' of cad14.sql
cat abc14t.txt | sed 's/abc/cad/g' > cad14t.txt

# cad14m.txt will be the 'middle' of cad14.sql
cat abcxyz.sql | sed 's/abc/cad/g' | sed 's/xyz/eur/g' > cad14m.txt
cat abcxyz.sql | sed 's/abc/cad/g' | sed 's/xyz/aud/g' >> cad14m.txt
cat abcxyz.sql | sed 's/abc/cad/g' | sed 's/xyz/gbp/g' >> cad14m.txt
cat abcxyz.sql | sed 's/abc/cad/g' | sed 's/xyz/jpy/g' >> cad14m.txt
cat abcxyz.sql | sed 's/abc/cad/g' | sed 's/xyz/cad/g' >> cad14m.txt
cat abcxyz.sql | sed 's/abc/cad/g' | sed 's/xyz/chf/g' >> cad14m.txt

# cad14b.txt will be the 'bottom' of cad14.sql
cat abc14b.txt | sed 's/abc/cad/g' > cad14b.txt

# cat together 
#   top,        middle,    bottom:
cat cad14t.txt  cad14m.txt cad14b.txt > cad14.sql
echo done with $0, cad14.sql has been built from a top, middle, bottom set of text files.
