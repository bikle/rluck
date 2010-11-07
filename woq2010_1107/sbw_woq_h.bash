#!/bin/bash

# sbw_woq_h.bash

. /pt/s/oracle/.orcl

set -x

sqt>sbw_woq_h.txt<<EOF
@sbw_woq_h.sql
EOF

cal 2010 >> sbw_woq_h.txt
