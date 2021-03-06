#!/bin/bash

# bld_gbp14.bash

# This script builds a sql script.

. /pt/s/rluck/svm8hp/.jruby

set -x

cd $SVM8HP
cd svm2/

# gbp14t.txt will be the 'top' of gbp14.sql
cat abc14t.txt | sed 's/abc/gbp/g' > gbp14t.txt

# gbp14m.txt will be the 'middle' of gbp14.sql
cat abcxyz.sql | sed 's/abc/gbp/g' | sed 's/xyz/eur/g' > gbp14m.txt
cat abcxyz.sql | sed 's/abc/gbp/g' | sed 's/xyz/aud/g' >> gbp14m.txt
cat abcxyz.sql | sed 's/abc/gbp/g' | sed 's/xyz/gbp/g' >> gbp14m.txt
cat abcxyz.sql | sed 's/abc/gbp/g' | sed 's/xyz/jpy/g' >> gbp14m.txt
cat abcxyz.sql | sed 's/abc/gbp/g' | sed 's/xyz/cad/g' >> gbp14m.txt
cat abcxyz.sql | sed 's/abc/gbp/g' | sed 's/xyz/chf/g' >> gbp14m.txt

# gbp14b.txt will be the 'bottom' of gbp14.sql
cat abc14b.txt | sed 's/abc/gbp/g' > gbp14b.txt

# cat together 
#   top,        middle,    bottom:
cat gbp14t.txt  gbp14m.txt gbp14b.txt > gbp14.sql
echo done with $0, gbp14.sql has been built from a top, middle, bottom set of text files.
