#!/bin/bash

# scorem.bash

# I use this as a shell wrapper for scorem.sql

. /pt/s/oracle/.orcl

set -x

date
sqt>scorem_out.txt<<EOF
@scorem.sql
EOF
date

exit
