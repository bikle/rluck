#!/bin/bash

# bld_ajp6.bash

# This script builds a sql script.

. /pt/s/rluck/svm6/.jruby

set -x

cd $SVM6
cd svm/

# ajp6t.txt will be the 'top' of ajp6.sql
cat abc6t.txt | sed 's/abc/ajp/g' > ajp6t.txt

# ajp6m.txt will be the 'middle' of ajp6.sql
cat abcxyz.sql | sed 's/abc/ajp/g' | sed 's/xyz/eur/g' > ajp6m.txt
cat abcxyz.sql | sed 's/abc/ajp/g' | sed 's/xyz/aud/g' >> ajp6m.txt
cat abcxyz.sql | sed 's/abc/ajp/g' | sed 's/xyz/gbp/g' >> ajp6m.txt
cat abcxyz.sql | sed 's/abc/ajp/g' | sed 's/xyz/jpy/g' >> ajp6m.txt
cat abcxyz.sql | sed 's/abc/ajp/g' | sed 's/xyz/cad/g' >> ajp6m.txt
cat abcxyz.sql | sed 's/abc/ajp/g' | sed 's/xyz/chf/g' >> ajp6m.txt

# ajp6b.txt will be the 'bottom' of ajp6.sql
cat abc6b.txt | sed 's/abc/ajp/g' > ajp6b.txt

# cat together 
#   top,        middle,    bottom:
cat ajp6t.txt  ajp6m.txt ajp6b.txt > ajp6.sql
echo done with $0, ajp6.sql has been built from a top, middle, bottom set of text files.
