/pt/s/rluck/svm4hp/readme.txt

The scripts in this directory implement an SVM based forex trading strategy.

Implementation of the strategy is simple:
  - Collect Forex prices once an hour for 6 pairs
  - Feed the prices to SVM
  - If SVM gives back a score above 0.7, then I open a position for 4 hours

The model I build for SVM is very wide.

Currently it has 2 + 6 x 36 columns.

Once the database is all setup and populated, the entry point each hour is this script:

run_svm4hp.bash

My intention is to eventually run this little beast from cron while I am off playing golf.

Right now it requires a lot of hand holding and trouble shooting.
