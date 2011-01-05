/pt/s/rluck/svmhstk/dukas/readme.txt

I use the files in this dir to download dukas data and then load it into: 
  - dukas1hr_stk

I have 2 entry points in this dir.

To download data from dukas use this script:
  - adhoc_curl.bash
  - It is a painful because the dukas site is a POS.

To load the CSV files into dukas1hr_stk use this script:
  - load_tkr_1hr.bash
  - Each CSV file should have about 2000 lines

The above script is wrapped by this script
  - load_many.bash

Both of the load scripts should be indempotent.

After the data is loaded, I can query it with this script:
  - qry_latest_price.sql

