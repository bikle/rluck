#!/bin/bash

# bld_aud4.bash

# This script builds a sql script.

. /pt/s/rluck/svm4/.jruby

set -x

cd $SVM4
cd svm/

# aud4t.txt will be the 'top' of aud4.sql
cat abc4t.txt | sed 's/abc/aud/g' > aud4t.txt

# aud4m.txt will be the 'middle' of aud4.sql
cat abcxyz.sql | sed 's/abc/aud/g' | sed 's/xyz/eur/g' > aud4m.txt
cat abcxyz.sql | sed 's/abc/aud/g' | sed 's/xyz/aud/g' >> aud4m.txt
cat abcxyz.sql | sed 's/abc/aud/g' | sed 's/xyz/gbp/g' >> aud4m.txt
cat abcxyz.sql | sed 's/abc/aud/g' | sed 's/xyz/jpy/g' >> aud4m.txt
cat abcxyz.sql | sed 's/abc/aud/g' | sed 's/xyz/cad/g' >> aud4m.txt
cat abcxyz.sql | sed 's/abc/aud/g' | sed 's/xyz/chf/g' >> aud4m.txt

# aud4b.txt will be the 'bottom' of aud4.sql
cat abc4b.txt | sed 's/abc/aud/g' > aud4b.txt

# cat together 
#   top,        middle,    bottom:
cat aud4t.txt  aud4m.txt aud4b.txt > aud4.sql
echo done with $0, aud4.sql has been built from a top, middle, bottom set of text files.
