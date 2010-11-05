#!/bin/bash

# qry_dom.bash

. /pt/s/oracle/.orcl

set -x

sqt>qry_dom.txt<<EOF
@qry_dom.sql
EOF
