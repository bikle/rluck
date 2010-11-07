#!/bin/bash

# dom.bash

# This is a simple shell wrapper for dom.sql

. /pt/s/oracle/.orcl

set -x

sqt>dom.txt<<EOF
@dom.sql
EOF
