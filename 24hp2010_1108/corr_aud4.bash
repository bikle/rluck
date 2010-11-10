#!/bin/bash

# corr_aud4.bash

. /pt/s/oracle/.orcl

set -x

# Get hdp in a good state:
sqt @24hp.sql

# Look for CORR():
sqt>>corr_aud4.txt<<EOF
@corr_aud4.sql
EOF

exit
