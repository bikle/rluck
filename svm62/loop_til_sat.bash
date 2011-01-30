#!/bin/bash

# loop_til_sat.bash

# This is a simple loop which keeps running until the calendar hits Saturday.

cd /pt/s/rluck/svm62/

the_day=`date +"%A"`
while [ -e "run_loop.txt" -a $the_day != 'Saturday' ]
do
  ./extra2.bash
  echo hello
  echo Now, it is:
  date
  the_day=`date +"%A"`
  echo Today is $the_day
  echo Now calling ./loop_z2.bash
  ./loop_z2.bash
  sleep 2
done

  