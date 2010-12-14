#!/bin/bash

# /pt/s/sb5/svm2/bld_eur14.bash

# This script builds a sql script.

# This script is both a working script and a template.

# eur14t.txt will be the 'top' of eur14.sql
cat abc14t.txt | sed '1,$s/abc/eur/g' > eur14t.txt

# eur14m.txt will be the 'middle' of eur14.sql
cat abcxyz.sql | sed '1,$s/abc/eur/g' | sed '1,$s/xyz/eur/g' > eur14m.txt
cat abcxyz.sql | sed '1,$s/abc/eur/g' | sed '1,$s/xyz/aud/g' >> eur14m.txt
cat abcxyz.sql | sed '1,$s/abc/eur/g' | sed '1,$s/xyz/gbp/g' >> eur14m.txt
cat abcxyz.sql | sed '1,$s/abc/eur/g' | sed '1,$s/xyz/jpy/g' >> eur14m.txt
cat abcxyz.sql | sed '1,$s/abc/eur/g' | sed '1,$s/xyz/cad/g' >> eur14m.txt
cat abcxyz.sql | sed '1,$s/abc/eur/g' | sed '1,$s/xyz/chf/g' >> eur14m.txt

# eur14b.txt will be the 'bottom' of eur14.sql
cat abc14b.txt | sed '1,$s/abc/eur/g' > eur14b.txt

# cat together 
#   top,        middle,    bottom:
cat eur14t.txt  eur14m.txt eur14b.txt > eur14.sql
echo done with $0, eur14.sql has been built from a top, middle, bottom set of text files.
