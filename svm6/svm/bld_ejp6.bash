#!/bin/bash

# bld_ejp6.bash

# This script builds a sql script.

. /pt/s/rluck/svm6/.jruby

set -x

cd $SVM6
cd svm/

# ejp6t.txt will be the 'top' of ejp6.sql
cat abc6t.txt | sed 's/abc/ejp/g' > ejp6t.txt

# ejp6m.txt will be the 'middle' of ejp6.sql
cat abcxyz.sql | sed 's/abc/ejp/g' | sed 's/xyz/eur/g' > ejp6m.txt
cat abcxyz.sql | sed 's/abc/ejp/g' | sed 's/xyz/aud/g' >> ejp6m.txt
cat abcxyz.sql | sed 's/abc/ejp/g' | sed 's/xyz/gbp/g' >> ejp6m.txt
cat abcxyz.sql | sed 's/abc/ejp/g' | sed 's/xyz/jpy/g' >> ejp6m.txt
cat abcxyz.sql | sed 's/abc/ejp/g' | sed 's/xyz/cad/g' >> ejp6m.txt
cat abcxyz.sql | sed 's/abc/ejp/g' | sed 's/xyz/chf/g' >> ejp6m.txt

# ejp6b.txt will be the 'bottom' of ejp6.sql
cat abc6b.txt | sed 's/abc/ejp/g' > ejp6b.txt

# cat together 
#   top,        middle,    bottom:
cat ejp6t.txt  ejp6m.txt ejp6b.txt > ejp6.sql
echo done with $0, ejp6.sql has been built from a top, middle, bottom set of text files.
