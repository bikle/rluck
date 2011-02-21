#!/bin/bash

set -x 
export myts=`date +%Y_%m_%d_%H_%M`

./svmpair.bash aud_usd
./svmpair.bash eur_usd
./svmpair.bash gbp_usd

./svmpair.bash usd_cad
./svmpair.bash usd_chf
./svmpair.bash usd_jpy

./svmpair.bash aud_jpy
## ./svmpair.bash eur_aud
./svmpair.bash eur_chf
./svmpair.bash eur_gbp
./svmpair.bash eur_jpy

