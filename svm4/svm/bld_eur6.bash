#!/bin/bash

# bld_eur6.bash

# This script builds a sql script.

# This script is both a working script and a template.
. /pt/s/rluck/svm6/.jruby

set -x

cd $SVM6
cd svm/

# eur6t.txt will be the 'top' of eur6.sql
cat abc6t.txt | sed 's/abc/eur/g' > eur6t.txt

# eur6m.txt will be the 'middle' of eur6.sql
cat abcxyz.sql | sed 's/abc/eur/g' | sed 's/xyz/eur/g' > eur6m.txt
cat abcxyz.sql | sed 's/abc/eur/g' | sed 's/xyz/aud/g' >> eur6m.txt
cat abcxyz.sql | sed 's/abc/eur/g' | sed 's/xyz/gbp/g' >> eur6m.txt
cat abcxyz.sql | sed 's/abc/eur/g' | sed 's/xyz/jpy/g' >> eur6m.txt
cat abcxyz.sql | sed 's/abc/eur/g' | sed 's/xyz/cad/g' >> eur6m.txt
cat abcxyz.sql | sed 's/abc/eur/g' | sed 's/xyz/chf/g' >> eur6m.txt

# eur6b.txt will be the 'bottom' of eur6.sql
cat abc6b.txt | sed 's/abc/eur/g' > eur6b.txt

# cat together 
#   top,        middle,    bottom:
cat eur6t.txt  eur6m.txt eur6b.txt > eur6.sql
echo done with $0, eur6.sql has been built from a top, middle, bottom set of text files.
