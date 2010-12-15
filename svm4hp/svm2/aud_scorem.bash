#!/bin/bash

# aud_scorem.bash

. /pt/s/rluck/svm4hp/.orcl

date

sqt>out_of_aud_scorem.txt<<EOF
@aud_scorem.sql
EOF

echo done

date
