#!/bin/bash

# qr4p.bash

set -x

sqlplus -S -M 'HTML ON SPOOL ON' trade/t >qr4p.txt<<EOF
@qr4p_css.txt
@qr4p.sql
EOF
