#!/bin/bash

# loop_zu_til_sat.bash

# This is a simple loop which keeps running until the calendar hits Saturday.

the_day=`date +"%A"`
while [ $the_day != 'Saturday' ]
do
  echo hello
  echo Now, it is:
  date
  the_day=`date +"%A"`
  echo Today is $the_day
  ./loop_zu.bash
  sleep 2
done

  