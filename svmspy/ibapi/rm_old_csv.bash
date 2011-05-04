#!/bin/bash

# rm_old_csv.bash

# I use this script to rm old csv files.

set -x
cd /pt/s/rluck/svmspy/ibapi/

find csv_files -name '*gmt.csv' -mtime +4 -print | xargs ls -ltr
find csv_files -name '*gmt.csv' -mtime +4 -print | xargs rm -f
