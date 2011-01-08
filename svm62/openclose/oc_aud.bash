#!/bin/bash

export myts=`date +%Y_%m_%d_%H_%M`
./oc.bash aud > /pt/s/cron/out/oc_bash.${myts}.txt 2>&1
