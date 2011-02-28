#!/bin/bash

# qr4p.bash

set -x

sqlplus -S trade/t >qr4p.txt<<EOF
@qr4p_css.txt
@qr4p.sql
EOF
