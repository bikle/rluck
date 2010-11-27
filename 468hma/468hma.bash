#!/bin/bash

# 468hma.bash

# This is a simple bash wrapper for 468hma.sql
. /pt/s/oracle/.orcl

set -x

# Start by deriving prices of 9 pairs from the 6-usd based pairs I have.

# The 9 additional pairs are listed below:
# eur_aud, eur_gbp, eur_cad, eur_chf, eur_jpy
# gbp_aud,          gbp_cad, gbp_chf, gbp_jpy

# h15c.sql calculates prices for these 9 additional pairs.
# It puts all the prices in the table h15c.
sqt>h15c.txt<<EOF
@h15c.sql
EOF

# I use 468hma.sql to study correlation between steep slopes of moving averages and price gains.
sqt>468hma.txt<<EOF
@468hma.sql
EOF

