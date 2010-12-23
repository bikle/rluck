#!/bin/bash

# rm_old_csv.bash

# I use this script to rm old csv files.

set -x

find csv_files -name 'USD*gmt.csv' -mtime +2 -print | xargs ls -ltr
find csv_files -name 'USD*gmt.csv' -mtime +2 -print | xargs rm -f
