#!/bin/bash

set -x

date

sqt>out_of_scorem_pair.txt<<EOF
@scorem_pair.sql
EOF

date

exit 0
