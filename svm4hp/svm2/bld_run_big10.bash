#!/bin/bash

# /pt/s/sb5/svm2/bld_run_big10.sql

# Edit copies of abc10.sql to make gbp10.sql, etc.

. /pt/s/oracle/.orcl

set -x
cd /pt/s/sb5/svm2/

cat abc10.sql | sed '1,$s/abc/eur/g' > eur10.sql
cat abc10.sql | sed '1,$s/abc/aud/g' > aud10.sql
cat abc10.sql | sed '1,$s/abc/gbp/g' > gbp10.sql
cat abc10.sql | sed '1,$s/abc/jpy/g' > jpy10.sql
cat abc10.sql | sed '1,$s/abc/cad/g' > cad10.sql
cat abc10.sql | sed '1,$s/abc/chf/g' > chf10.sql
cat abc10.sql | sed '1,$s/abc/egb/g' > egb10.sql
cat abc10.sql | sed '1,$s/abc/eau/g' > eau10.sql
cat abc10.sql | sed '1,$s/abc/ejp/g' > ejp10.sql
cat abc10.sql | sed '1,$s/abc/eca/g' > eca10.sql
cat abc10.sql | sed '1,$s/abc/ech/g' > ech10.sql
cat abc10.sql | sed '1,$s/abc/gau/g' > gau10.sql
cat abc10.sql | sed '1,$s/abc/gjp/g' > gjp10.sql
cat abc10.sql | sed '1,$s/abc/gca/g' > gca10.sql
cat abc10.sql | sed '1,$s/abc/gch/g' > gch10.sql

cat \
eur10.sql \
aud10.sql \
gbp10.sql \
jpy10.sql \
cad10.sql \
chf10.sql \
egb10.sql \
eau10.sql \
ejp10.sql \
eca10.sql \
ech10.sql \
gau10.sql \
gjp10.sql \
gca10.sql \
gch10.sql \
|grep -v exit > big10.sql

sqt>out_of_big10.txt<<EOF
@big10.sql
EOF

# Look for errors
grep -i error out_of_big10.txt | wc -l
