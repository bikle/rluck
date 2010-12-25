#!/bin/bash

# bld_eur4.bash

# This script builds a sql script.

# This script is both a working script and a template.
. /pt/s/rluck/svm4/.jruby

set -x

cd $SVM4
cd svm/

# eur4t.txt will be the 'top' of eur4.sql
cat abc4t.txt | sed 's/abc/eur/g' > eur4t.txt

# eur4m.txt will be the 'middle' of eur4.sql
cat abcxyz.sql | sed 's/abc/eur/g' | sed 's/xyz/eur/g' > eur4m.txt
cat abcxyz.sql | sed 's/abc/eur/g' | sed 's/xyz/aud/g' >> eur4m.txt
cat abcxyz.sql | sed 's/abc/eur/g' | sed 's/xyz/gbp/g' >> eur4m.txt
cat abcxyz.sql | sed 's/abc/eur/g' | sed 's/xyz/jpy/g' >> eur4m.txt
cat abcxyz.sql | sed 's/abc/eur/g' | sed 's/xyz/cad/g' >> eur4m.txt
cat abcxyz.sql | sed 's/abc/eur/g' | sed 's/xyz/chf/g' >> eur4m.txt

# eur4b.txt will be the 'bottom' of eur4.sql
cat abc4b.txt | sed 's/abc/eur/g' > eur4b.txt

# cat together 
#   top,        middle,    bottom:
cat eur4t.txt  eur4m.txt eur4b.txt > eur4.sql
echo done with $0, eur4.sql has been built from a top, middle, bottom set of text files.
