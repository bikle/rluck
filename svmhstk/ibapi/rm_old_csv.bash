#!/bin/bash

# rm_old_csv.bash

# I use this script to rm old csv files.

set -x

cd /pt/s/rluck/svmhstk/ibapi/

find csv_files -name '*gmt.csv' -mtime +5 -print | xargs ls -ltr

find csv_files -name '*gmt.csv' -mtime +5 -print | xargs rm -f

exit 0

