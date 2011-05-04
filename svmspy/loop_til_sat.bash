#!/bin/bash

# loop_til_sat.bash

# I use this script to run SVM in a loop.
# I want this script to end itself on Saturday or until it cannot see file: run_loop.txt

. /pt/s/rluck/svmspy/.orcl
. /pt/s/rluck/svmspy/.jruby

set -x

date

cd $SVMSPY

the_day=`date +"%A"`
# while [ $the_day != 'Saturday' ]
while [ -e "run_loop.txt" -a $the_day != 'Saturday' ]
do
  echo hello
  echo Now, it is:
  date
  the_day=`date +"%A"`
  echo Today is $the_day
  ./loop_0503.bash
  ./extra.bash
  sleep 5
done
