#!/bin/bash

# build_scorem.bash

# This is a simple shell wrapper for build_scorem.sql

. /pt/s/oracle/.orcl

set -x

sqt>scorem.txt<<EOF
@build_scorem.sql
EOF

# Massage the output txt into a sql script
grep score1hr scorem.txt | grep -v SELECT > scorem.sql

exit
