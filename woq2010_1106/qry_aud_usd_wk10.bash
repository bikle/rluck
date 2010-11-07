#!/bin/bash

# qry_aud_usd_wk10.bash

# This is a shell wrapper for qry_aud_usd_wk10.sql

. /pt/s/oracle/.orcl

set -x

sqt>qry_aud_usd_wk10.txt<<EOF
@qry_aud_usd_wk10.sql
EOF
