#!/bin/bash

# chf_scorem.bash

. /pt/s/rluck/svm8hp/.orcl

date

sqt>out_of_chf_scorem.txt<<EOF
@chf_scorem.sql
EOF

echo done

date
