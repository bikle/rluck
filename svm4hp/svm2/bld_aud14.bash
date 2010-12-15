#!/bin/bash

# bld_aud14.bash

# This script builds a sql script.


set -x

cd $SVM4HP
cd svm2/

# aud14t.txt will be the 'top' of aud14.sql
cat abc14t.txt | sed 's/abc/aud/g' > aud14t.txt

# aud14m.txt will be the 'middle' of aud14.sql
cat abcxyz.sql | sed 's/abc/aud/g' | sed 's/xyz/eur/g' > aud14m.txt
cat abcxyz.sql | sed 's/abc/aud/g' | sed 's/xyz/aud/g' >> aud14m.txt
cat abcxyz.sql | sed 's/abc/aud/g' | sed 's/xyz/gbp/g' >> aud14m.txt
cat abcxyz.sql | sed 's/abc/aud/g' | sed 's/xyz/jpy/g' >> aud14m.txt
cat abcxyz.sql | sed 's/abc/aud/g' | sed 's/xyz/cad/g' >> aud14m.txt
cat abcxyz.sql | sed 's/abc/aud/g' | sed 's/xyz/chf/g' >> aud14m.txt

# aud14b.txt will be the 'bottom' of aud14.sql
cat abc14b.txt | sed 's/abc/aud/g' > aud14b.txt

# cat together 
#   top,        middle,    bottom:
cat aud14t.txt  aud14m.txt aud14b.txt > aud14.sql
echo done with $0, aud14.sql has been built from a top, middle, bottom set of text files.
