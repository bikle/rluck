#!/bin/bash

# bld_chf14.bash

# This script builds a sql script.


set -x

cd $SVM4HP
cd svm2/

# chf14t.txt will be the 'top' of chf14.sql
cat abc14t.txt | sed 's/abc/chf/g' > chf14t.txt

# chf14m.txt will be the 'middle' of chf14.sql
cat abcxyz.sql | sed 's/abc/chf/g' | sed 's/xyz/eur/g' > chf14m.txt
cat abcxyz.sql | sed 's/abc/chf/g' | sed 's/xyz/aud/g' >> chf14m.txt
cat abcxyz.sql | sed 's/abc/chf/g' | sed 's/xyz/gbp/g' >> chf14m.txt
cat abcxyz.sql | sed 's/abc/chf/g' | sed 's/xyz/jpy/g' >> chf14m.txt
cat abcxyz.sql | sed 's/abc/chf/g' | sed 's/xyz/cad/g' >> chf14m.txt
cat abcxyz.sql | sed 's/abc/chf/g' | sed 's/xyz/chf/g' >> chf14m.txt

# chf14b.txt will be the 'bottom' of chf14.sql
cat abc14b.txt | sed 's/abc/chf/g' > chf14b.txt

# cat together 
#   top,        middle,    bottom:
cat chf14t.txt  chf14m.txt chf14b.txt > chf14.sql
echo done with $0, chf14.sql has been built from a top, middle, bottom set of text files.
