#!/bin/bash

# bld_gbp6.bash

# This script builds a sql script.

. /pt/s/rluck/svm6/.jruby

set -x

cd $SVM6
cd svm/

# gbp6t.txt will be the 'top' of gbp6.sql
cat abc6t.txt | sed 's/abc/gbp/g' > gbp6t.txt

# gbp6m.txt will be the 'middle' of gbp6.sql
cat abcxyz.sql | sed 's/abc/gbp/g' | sed 's/xyz/eur/g' > gbp6m.txt
cat abcxyz.sql | sed 's/abc/gbp/g' | sed 's/xyz/aud/g' >> gbp6m.txt
cat abcxyz.sql | sed 's/abc/gbp/g' | sed 's/xyz/gbp/g' >> gbp6m.txt
cat abcxyz.sql | sed 's/abc/gbp/g' | sed 's/xyz/jpy/g' >> gbp6m.txt
cat abcxyz.sql | sed 's/abc/gbp/g' | sed 's/xyz/cad/g' >> gbp6m.txt
cat abcxyz.sql | sed 's/abc/gbp/g' | sed 's/xyz/chf/g' >> gbp6m.txt

# gbp6b.txt will be the 'bottom' of gbp6.sql
cat abc6b.txt | sed 's/abc/gbp/g' > gbp6b.txt

# cat together 
#   top,        middle,    bottom:
cat gbp6t.txt  gbp6m.txt gbp6b.txt > gbp6.sql
echo done with $0, gbp6.sql has been built from a top, middle, bottom set of text files.
