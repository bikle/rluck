#!/bin/bash

set -x 
export myts=`date +%Y_%m_%d_%H_%M`

./svmpair.bash aud_usd
exit

./svmpair.bash eur_usd
./svmpair.bash gbp_usd

./svmpair.bash usd_cad
./svmpair.bash usd_chf
./svmpair.bash usd_jpy

./svmpair.bash ech_usd
./svmpair.bash egb_usd
./svmpair.bash eau_usd
./svmpair.bash ejp_usd
./svmpair.bash ajp_usd
